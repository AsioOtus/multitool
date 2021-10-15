extension And {
	public struct Result: MultipleResultProtocol {
		public let results: [ProcessingResult<Value, Failure>]
		public let summary: SingleResult<Value, Failure>
		
		init (_ results: [ProcessingResult<Value, Failure>], _ value: Value, _ failure: Failure?) {
			self.results = results
			
			self.summary = {
				if let failedResult = results.first(where: { !$0.summary.outcome.isSuccess }) {
					return
						.init(
							failure.map{ .failure($0) } ?? failedResult.summary.outcome,
							And.name,
							failedResult.summary.label
						)
					
				} else {
					return
						.init(
							.success(value),
							And.name
						)
				}
			}()
		}
	}
}

public struct And <Value, Failure>: ProcessorProtocol {
	public static var name: String { "and" }
	
	public let processors: [AnyProcessor<Value, Failure>]
	public let failure: (Value) -> Failure?
	
	public init (failure: @escaping (Value) -> Failure? = { _ in nil }, _ processors: [AnyProcessor<Value, Failure>]) {
		self.processors = processors
		self.failure = failure
	}
	
	public func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		var results = [ProcessingResult<Value, Failure>]()
		
		var value = value
		for processor in processors {
			let result = processor.process(value)
			results.append(result)
			
			guard case .success(let processedValue) = result.summary.outcome else { break }
			value = processedValue
		}
		
		let failure = failure(value)
		return .multiple(Result(results, value, failure).eraseToAnyMultipleResult())
	}
}

public extension AnyProcessor {
	static func and (failure: @escaping (Value) -> Failure? = { _ in nil }, _ processors: [Self]) -> Self {
		And(failure: failure, processors).eraseToAnyProcessor()
	}
	
	static func and (failure: @escaping (Value) -> Failure? = { _ in nil }, @ArrayBuilder _ processors: () -> ([Self])) -> Self {
		And(failure: failure, processors()).eraseToAnyProcessor()
	}
}


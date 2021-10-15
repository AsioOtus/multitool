extension First {
	public struct Result: MultipleResultProtocol {
		public let results: [ProcessingResult<Value, Failure>]
		public let summary: SingleResult<Value, Failure>
		
		init (_ results: [ProcessingResult<Value, Failure>], _ value: Value, _ failure: Failure?) {
			self.results = results
			self.summary = {
				if let firstSuccessResult = results.first(where: { $0.summary.outcome.isSuccess }) {
					return .init(firstSuccessResult.summary.outcome, First.name, firstSuccessResult.summary.label)
					
				} else if let lastFailureResult = results.last(where: { !$0.summary.outcome.isSuccess }) {
					return .init(failure.map{ .failure($0) } ?? lastFailureResult.summary.outcome, First.name)
					
				} else {
					return .init(.success(value), First.name)
				}
			}()
		}
	}
}

public struct First <Value, Failure>: ProcessorProtocol {
	public static var name: String { "first" }
	
	public let processors: [AnyProcessor<Value, Failure>]
	public let failure: (Value) -> Failure?
	
	public init (failure: @escaping (Value) -> Failure? = { _ in nil }, _ processors: [AnyProcessor<Value, Failure>]) {
		self.processors = processors
		self.failure = failure
	}
	
	public func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		var results = [ProcessingResult<Value, Failure>]()
		
		for processor in processors {
			let result = processor.process(value)
			results.append(result)
			
			guard case .failure = result.summary.outcome else { break }
		}
		
		let failure = failure(value)
		return .multiple(Result(results, value, failure).eraseToAnyMultipleResult())
	}
}

public extension AnyProcessor {
	static func first (failure: @escaping (Value) -> Failure? = { _ in nil }, _ processors: [Self]) -> Self {
		First(failure: failure, processors).eraseToAnyProcessor()
	}
	
	static func first (failure: @escaping (Value) -> Failure? = { _ in nil }, @ArrayBuilder _ processors: () -> ([Self])) -> Self {
		First(failure: failure, processors()).eraseToAnyProcessor()
	}
}

extension Last {
	public struct Result: MultipleResultProtocol {
		public let results: [ProcessingResult<Value, Failure>]
		public let summary: SingleResult<Value, Failure>
		
		init (_ results: [ProcessingResult<Value, Failure>], _ value: Value, _ failure: Failure?) {
			self.results = results
			self.summary = {
				if let lastSuccessResult = results.last(where: { $0.summary.outcome.isSuccess }) {
					return .init(lastSuccessResult.summary.outcome, Last.name, lastSuccessResult.summary.label)
					
				} else if let lastFailureResult = results.last(where: { !$0.summary.outcome.isSuccess }) {
					return .init(failure.map{ .failure($0) } ?? lastFailureResult.summary.outcome, Last.name)
					
				} else {
					return .init(.success(value), Last.name)
				}
			}()
		}
	}
}

public struct Last <Value, Failure>: ProcessorProtocol {
	public static var name: String { "last" }
	
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
			
			guard case .success(let processedValue) = result.summary.outcome else { continue }
			value = processedValue
		}
		
		let failure = failure(value)
		return .multiple(Result(results, value, failure).eraseToAnyMultipleResult())
	}
}

public extension AnyProcessor {
	static func last (failure: @escaping (Value) -> Failure? = { _ in nil }, _ processors: [Self]) -> Self {
		Last(failure: failure, processors).eraseToAnyProcessor()
	}
	
	static func last (failure: @escaping (Value) -> Failure? = { _ in nil }, @ArrayBuilder _ processors: () -> ([Self])) -> Self {
		Last(failure: failure, processors()).eraseToAnyProcessor()
	}
}

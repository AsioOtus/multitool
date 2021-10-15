extension First {
	public struct Result: MultipleResultProtocol {
		public let results: [ProcessingResult<Value, Failure>]
		public let summary: SingleResult<Value, Failure>
		
		public init (_ results: [ProcessingResult<Value, Failure>], _ value: Value) {
			self.results = results
			self.summary = {
				if let firstSuccessResult = results.first(where: { $0.summary.outcome.isSuccess }) {
					return .init(firstSuccessResult.summary.outcome, First.name, firstSuccessResult.summary.label)
				} else if let lastFailureResult = results.last(where: { !$0.summary.outcome.isSuccess }) {
					return .init(lastFailureResult.summary.outcome, First.name)
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
	
	public init (_ processors: [AnyProcessor<Value, Failure>]) {
		self.processors = processors
	}
	
	public func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		var results = [ProcessingResult<Value, Failure>]()
		
		for processor in processors {
			let result = processor.process(value)
			results.append(result)
			
			guard case .failure = result.summary.outcome else { break }
		}
		
		return .multiple(Result(results, value).eraseToAnyMultipleResult())
	}
}

public extension AnyProcessor {
	static func first (_ processors: [Self]) -> Self {
		First(processors).eraseToAnyProcessor()
	}
	
	static func first (@ArrayBuilder _ processors: () -> ([Self])) -> Self {
		First(processors()).eraseToAnyProcessor()
	}
}

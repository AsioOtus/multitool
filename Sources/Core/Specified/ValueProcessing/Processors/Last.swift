extension Last {
	public struct Result: MultipleResultProtocol {
		public let results: [ProcessingResult<Value, Failure>]
		public let summary: SingleResult<Value, Failure>
		
		public init (_ results: [ProcessingResult<Value, Failure>], _ value: Value, _ label: String? = nil) {
			self.results = results
			self.summary = {
				if let lastSuccessResult = results.last(where: { $0.summary.outcome.isSuccess }) {
					return .init(lastSuccessResult.summary.outcome, Last.name, lastSuccessResult.summary.label)
					
				} else if let lastFailureResult = results.last(where: { !$0.summary.outcome.isSuccess }) {
					return .init(lastFailureResult.summary.outcome, Last.name)
					
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
	
	public init (_ processors: [AnyProcessor<Value, Failure>]) {
		self.processors = processors
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
		
		return .multiple(Result(results, value).eraseToAnyMultipleResult())
	}
}

public extension AnyProcessor {
	static func last (_ processors: [Self]) -> Self {
		Last(processors).eraseToAnyProcessor()
	}
	
	static func last (@ArrayBuilder _ processors: () -> ([Self])) -> Self {
		Last(processors()).eraseToAnyProcessor()
	}
}


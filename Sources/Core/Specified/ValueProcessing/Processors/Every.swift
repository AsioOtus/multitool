extension Every {
	public struct Result: MultipleResultProtocol {
		public let results: [ProcessingResult<Value, Failure>]
		public let summary: SingleResult<Value, Failure>
		
		public init (_ results: [ProcessingResult<Value, Failure>], _ value: Value, _ label: String? = nil) {
			self.results = results
			self.summary = {
				if let firstSuccessResult = results.last(where: { $0.summary.outcome.isSuccess }) {
					return .init(firstSuccessResult.summary.outcome, Every.name)
					
				} else if let lastFailureResult = results.last(where: { !$0.summary.outcome.isSuccess }) {
					return .init(lastFailureResult.summary.outcome, Every.name)
					
				} else {
					return .init(.success(value), Every.name)
				}
			}()
		}
	}
}

public struct Every <Value, Failure>: ProcessorProtocol {
	public static var name: String { "every" }
	
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
			
			if case .success(let processedValue) = result.summary.outcome {
				value = processedValue
			}
		}
		
		return .multiple(Result(results, value).eraseToAnyMultipleResult())
	}
}

public extension AnyProcessor {
	static func every (_ processors: [Self]) -> Self {
		Every(processors).eraseToAnyProcessor()
	}
	
	static func every (@ArrayBuilder _ processors: () -> ([Self])) -> Self {
		Every(processors()).eraseToAnyProcessor()
	}
}


extension Every {
	public struct Result: MultipleResultProtocol {
		public let results: [ProcessingResult<Value, Failure>]
		public let summaryResult: SingleResult<Value, Failure>
		
		public init (_ results: [ProcessingResult<Value, Failure>], _ value: Value, _ label: String? = nil) {
			self.results = results
			self.summaryResult = {
				guard !results.isEmpty else { return .init(.success(value), Every.name) }
				
				if let lastSuccessResult = results.last(where: { $0.summaryResult.category.isSuccess }) {
					return .init(lastSuccessResult.summaryResult.category, Every.name, lastSuccessResult.summaryResult.label)
				} else {
					return .init(.failure(), Every.name)
				}
			}()
		}
	}
}

public struct Every <Value, Failure>: ProcessorProtocol {
	public static var name: String { "every" }
	
	public let failure: Failure?
	
	public let processors: [AnyProcessor<Value, Failure>]
	
	public init (failure: Failure? = nil, _ processors: [AnyProcessor<Value, Failure>]) {
		self.failure = failure
		self.processors = processors
	}
	
	public func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		var results = [ProcessingResult<Value, Failure>]()
		
		var value = value
		for processor in processors {
			let result = processor.process(value)
			results.append(result)
			
			if case .success(let processedValue) = result.summaryResult.category {
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


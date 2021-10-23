extension Whatever {
	public struct Result: MultipleResultProtocol {
		public let results: [ProcessingResult<Value, Failure>]
		public let summary: SingleResult<Value, Failure>
		
		init (_ results: [ProcessingResult<Value, Failure>], _ value: Value) {
			self.results = results
			self.summary = { .init(.success(value), Whatever.name) }()
		}
	}
}

public struct Whatever <Value, Failure>: ProcessorProtocol {
	public static var name: String { "whatever" }
	
	public let processors: [AnyProcessor<Value, Failure>]
	
	public init (_ processors: [AnyProcessor<Value, Failure>]) {
		self.processors = processors
	}
	
	public func process (_ originalValue: Value) -> ProcessingResult<Value, Failure> {
		var results = [ProcessingResult<Value, Failure>]()
		
		var value = originalValue
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
	static func whatever (_ processors: [Self]) -> Self {
		Whatever(processors).eraseToAnyProcessor()
	}
	
	static func whatever (@ProcessorBuilder _ processors: () -> ([Self])) -> Self {
		Whatever(processors()).eraseToAnyProcessor()
	}
}

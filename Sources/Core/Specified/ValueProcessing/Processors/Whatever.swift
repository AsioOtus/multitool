extension Whatever {
	public struct Result: MultipleResultProtocol {
		public let results: [ProcessingResult<Value, Failure>]
		public let summaryResult: SingleResult<Value, Failure>
		
		public init (_ results: [ProcessingResult<Value, Failure>], _ value: Value) {
			self.results = results
			self.summaryResult = {
				return .init(.success(value), Whatever.name)
			}()
		}
	}
}

public struct Whatever <Value, Failure>: ProcessorProtocol {
	public static var name: String { "whatever" }
	
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
			
			if case .success(let processedValue) = result.summaryResult.category {
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
	
	static func whatever (@ArrayBuilder _ processors: () -> ([Self])) -> Self {
		Whatever(processors()).eraseToAnyProcessor()
	}
}

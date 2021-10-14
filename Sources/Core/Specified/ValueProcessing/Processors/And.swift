extension And {
	public struct Result: MultipleResultProtocol {
		public let results: [ProcessingResult<Value, Failure>]
		public let summaryResult: SingleResult<Value, Failure>
		
		public init (_ results: [ProcessingResult<Value, Failure>], _ value: Value, _ label: String? = nil) {
			self.results = results
			
			self.summaryResult = {
				if let failedResult = results.first(where: { !$0.summaryResult.category.isSuccess }) {
					return .init(failedResult.summaryResult.category, And.name, failedResult.summaryResult.label)
				} else {
					return .init(.success(value), And.name)
				}
			}()
		}
	}
}

public struct And <Value, Failure>: ProcessorProtocol {
	public static var name: String { "and" }
	
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
			
			guard case .success(let processedValue) = result.summaryResult.category else { break }
			value = processedValue
		}
		
		return .multiple(Result(results, value).eraseToAnyMultipleResult())
	}
}

public extension AnyProcessor {
	static func and (_ processors: [Self]) -> Self {
		And(processors).eraseToAnyProcessor()
	}
	
	static func and (@ArrayBuilder _ processors: () -> ([Self])) -> Self {
		And(processors()).eraseToAnyProcessor()
	}
}


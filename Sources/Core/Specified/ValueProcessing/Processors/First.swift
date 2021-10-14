extension First {
	public struct Result: MultipleResultProtocol {
		public let results: [ProcessingResult<Value, Failure>]
		public let summaryResult: SingleResult<Value, Failure>
		
		public init (_ results: [ProcessingResult<Value, Failure>], _ value: Value) {
			self.results = results
			self.summaryResult = {
				guard !results.isEmpty else { return .init(.success(value), First.name) }
				
				if let firstSuccessResult = results.first(where: {
					if case .success = $0.summaryResult.category { return true }
					else { return false }
				}) {
					return .init(firstSuccessResult.summaryResult.category, First.name, firstSuccessResult.summaryResult.label)
				} else {
					return .init(.failure(), First.name)
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
			
			guard case .failure = result.summaryResult.category else { break }
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

public struct And <Value, Failure>: ProcessorProtocol {
	public static var name: String { "and" }
	
	public let processors: [AnyProcessor<Value, Failure>]
	public let failure: (Value) -> Failure?
	
	public init (failure: @escaping (Value) -> Failure? = { _ in nil }, _ processors: [AnyProcessor<Value, Failure>]) {
		self.processors = processors
		self.failure = failure
	}
	
	public func process (_ originalValue: Value) -> ProcessingResult<Value, Failure> {
		var results = [ProcessingResult<Value, Failure>]()
		
		var value = originalValue
		for processor in processors {
			let result = processor.process(value)
			results.append(result)
			
			guard case .success(let processedValue) = result.summary.outcome else { break }
			value = processedValue
		}
		
		let failure = failure(originalValue)
		return .multiple(.init(results: results, summary: summary(results, value, failure)))
	}
	
	private func summary (_ results: [ProcessingResult<Value, Failure>], _ value: Value, _ failure: Failure?) -> SingleResult<Value, Failure> {
		if let failedResult = results.first(where: { !$0.summary.outcome.isSuccess }) {
			return
				.init(
					failure.map{ .failure($0) } ?? failedResult.summary.outcome,
					Self.name,
					failedResult.summary.label
				)
		} else {
			return .init(.success(value), Self.name)
		}
	}
}

public extension AnyProcessor {
	static func and (failure: @escaping (Value) -> Failure? = { _ in nil }, _ processors: [Self]) -> Self {
		And(failure: failure, processors).eraseToAnyProcessor()
	}
	
	static func and (failure: @escaping (Value) -> Failure? = { _ in nil }, @ProcessorBuilder _ processors: () -> ([Self])) -> Self {
		And(failure: failure, processors()).eraseToAnyProcessor()
	}
}


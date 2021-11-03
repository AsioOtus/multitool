public struct Last <Value, Failure>: ProcessorProtocol {
	public static var name: String { "last" }
	
	public let processors: [AnyProcessor<Value, Failure>]
	public let failure: (Value) -> Failure?
	
	public init (failure: @escaping (Value) -> Failure? = { _ in nil }, _ processors: [AnyProcessor<Value, Failure>]) {
		self.processors = processors
		self.failure = failure
	}
	
	public init (failure: Failure?, _ processors: [AnyProcessor<Value, Failure>]) {
		self.init(failure: { _ in failure }, processors)
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
		
		let failure = failure(originalValue)
		return .multiple(.init(results: results, summary: summary(results, value, failure)))
	}
	
	private func summary (_ results: [ProcessingResult<Value, Failure>], _ value: Value, _ failure: Failure?) -> SingleResult<Value, Failure> {
		if let lastSuccessResult = results.last(where: { $0.summary.outcome.isSuccess }) {
			return .init(lastSuccessResult.summary.outcome, Self.name, lastSuccessResult.summary.label)
		} else if let lastFailureResult = results.last(where: { !$0.summary.outcome.isSuccess }) {
			return .init(failure.map{ .failure($0) } ?? lastFailureResult.summary.outcome, Self.name)
		} else {
			return .init(.success(value), Self.name)
		}
	}
}

public extension AnyProcessor {
	static func last (failure: @escaping (Value) -> Failure? = { _ in nil }, _ processors: [Self]) -> Self {
		Last(failure: failure, processors).eraseToAnyProcessor()
	}
	
	static func last (failure: Failure?, _ processors: [Self]) -> Self {
		Last(failure: failure, processors).eraseToAnyProcessor()
	}
	
	static func last (failure: @escaping (Value) -> Failure? = { _ in nil }, @ProcessorBuilder _ processors: () -> ([Self])) -> Self {
		Last(failure: failure, processors()).eraseToAnyProcessor()
	}
	
	static func last (failure: Failure?, @ProcessorBuilder _ processors: () -> ([Self])) -> Self {
		Last(failure: failure, processors()).eraseToAnyProcessor()
	}
}


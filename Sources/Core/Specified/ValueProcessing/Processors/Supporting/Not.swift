public struct Not <Value, Failure>: ProcessorProtocol {
	public static var name: String { "not" }
	
	public let processor: AnyProcessor<Value, Failure>
	public let failure: Failure
	
	public init (failure: Failure, _ processor: AnyProcessor<Value, Failure>) {
		self.processor = processor
		self.failure = failure
	}
	
	public func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		let processingResult = processor.process(value)
		if case .success = processingResult.summary.outcome {
			return .single(.init(.failure(failure), Not.name, label))
		} else {
			return .single(.init(.success(value), Not.name, label))
		}
	}
}

public extension AnyProcessor {
	static func not (_ processor: AnyProcessor<Value, Failure>, failure: Failure) -> Self {
		Not(failure: failure, processor).eraseToAnyProcessor()
	}
}

public extension AnyProcessor where Failure == Optional<Any> {
	static func not (_ processor: AnyProcessor<Value, Failure>, failure: Failure = nil) -> Self {
		Not(failure: failure, processor).eraseToAnyProcessor()
	}
}

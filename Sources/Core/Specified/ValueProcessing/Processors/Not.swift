public struct Not <Value, Failure>: ProcessorProtocol {
	public static var name: String { "not" }
	
	public let processor: AnyProcessor<Value, Failure>
	public let failure: Failure?
	
	public init (_ processor: AnyProcessor<Value, Failure>, _ failure: Failure? = nil) {
		self.processor = processor
		self.failure = failure
	}
	
	public func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		let processingResult = processor.process(value)
		if case .success = processingResult.summaryResult.category {
			return .single(.init(.failure(failure), Not.name, label))
		} else {
			return .single(.init(.success(value), Not.name, label))
		}
	}
}

public extension AnyProcessor {
	static func not (_ processor: AnyProcessor<Value, Failure>, _ failure: Failure? = nil) -> Self {
		Not(processor, failure).eraseToAnyProcessor()
	}
}

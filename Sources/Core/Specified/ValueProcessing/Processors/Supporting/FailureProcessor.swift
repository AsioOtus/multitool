public struct FailureProcessor <Value, Failure>: ProcessorProtocol {
	public static var name: String { "failure" }
	
	public let failure: Failure
	
	public let label: String?
	
	public init (label: String? = nil, _ failure: Failure) {
		self.label = label
		self.failure = failure
	}
	
	public func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		.single(.init(.failure(failure), FailureProcessor.name, label))
	}
}

public extension AnyProcessor {
	static func failure (label: String? = nil, _ failure: Failure) -> Self {
		FailureProcessor(label: label, failure).eraseToAnyProcessor()
	}
}

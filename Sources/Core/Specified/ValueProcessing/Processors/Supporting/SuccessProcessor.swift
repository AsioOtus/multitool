public struct SuccessProcessor <Value, Failure>: ProcessorProtocol {
	public static var name: String { "success" }
	
	public let label: String?
	
	public init (label: String? = nil) {
		self.label = label
	}
	
	public func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		.single(.init(.success(value), SuccessProcessor.name, label))
	}
}

public extension AnyProcessor {
	static func success (label: String? = nil) -> Self {
		SuccessProcessor(label: label).eraseToAnyProcessor()
	}
}

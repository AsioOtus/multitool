public struct ValueProcessor <Value, Failure>: ProcessorProtocol {
	public static var name: String { "value" }
	
	public let label: String?
	public let value: Value
	
	public init (label: String? = nil, _ value: Value) {
		self.label = label
		self.value = value
	}
	
	public func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		.single(.init(.success(self.value), ValueProcessor.name, label))
	}
}

public extension AnyProcessor {
	static func value (label: String? = nil, _ value: Value) -> Self {
		ValueProcessor(label: label, value).eraseToAnyProcessor()
	}
}

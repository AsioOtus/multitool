public struct Processing <Value, Failure>: ProcessorProtocol {
	public static var name: String { "processing" }
	
	public let label: String?
	
	public let processing: (Value) -> Value
	
	public init (label: String? = nil, processing: @escaping (Value) -> Value) {
		self.label = label
		self.processing = processing
	}
	
	public func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		let processedValue = processing(value)
		return .single(.init(.success(processedValue), Self.name, label))
	}
}

public extension AnyProcessor {
	static func process (label: String? = nil, processing: @escaping (Value) -> Value) -> Self {
		Processing(label: label, processing: processing).eraseToAnyProcessor()
	}
	
	static func process (_ processing: Processing<Value, Failure>) -> Self {
		processing.eraseToAnyProcessor()
	}
}

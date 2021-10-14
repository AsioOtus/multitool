public struct Modifier <Value, Failure>: ProcessorProtocol {
	public let label: String?
	
	public let modification: (Value) -> Value
	public let processor: AnyProcessor<Value, Failure>
	
	public init (label: String? = nil, _ modification: @escaping (Value) -> Value, _ processor: AnyProcessor<Value, Failure>) {
		self.label = label
		self.modification = modification
		self.processor = processor
	}
	
	public func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		let modifiedValue = modification(value)
		return processor.process(modifiedValue)
	}
}

public extension AnyProcessor {
	static func modifier (label: String? = nil, _ modification: @escaping (Value) -> Value, _ processor: AnyProcessor<Value, Failure>) -> Self {
		Modifier(label: label, modification, processor).eraseToAnyProcessor()
	}
	
	static func modifier (_ modifier: Modifier<Value, Failure>) -> Self {
		modifier.eraseToAnyProcessor()
	}
}

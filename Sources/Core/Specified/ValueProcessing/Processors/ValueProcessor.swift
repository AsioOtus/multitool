struct ValueProcessor <Value, Failure>: ProcessorProtocol {
	static var name: String { "value" }
	
	let label: String?
	let value: Value
	
	init (label: String? = nil, _ value: Value) {
		self.label = label
		self.value = value
	}
	
	func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		.single(.init(.success(self.value), ValueProcessor.name, label))
	}
}

extension AnyProcessor {
	static func value (label: String? = nil, _ value: Value) -> Self {
		ValueProcessor(label: label, value).eraseToAnyProcessor()
	}
}

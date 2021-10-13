struct Modifier <Value, Failure>: ProcessorProtocol {	
	let label: String?
	
	let modification: (Value) -> Value
	let processor: AnyProcessor<Value, Failure>
	
	init (label: String? = nil, _ modification: @escaping (Value) -> Value, _ processor: AnyProcessor<Value, Failure>) {
		self.label = label
		self.modification = modification
		self.processor = processor
	}
	
	func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		let modifiedValue = modification(value)
		return processor.process(modifiedValue)
	}
}

extension AnyProcessor {
	static func modifier (label: String? = nil, _ modification: @escaping (Value) -> Value, _ processor: AnyProcessor<Value, Failure>) -> Self {
		Modifier(label: label, modification, processor).eraseToAnyProcessor()
	}
	
	static func modifier (_ modifier: Modifier<Value, Failure>) -> Self {
		modifier.eraseToAnyProcessor()
	}
}

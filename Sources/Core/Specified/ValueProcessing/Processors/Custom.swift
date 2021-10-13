struct Custom <Value, Failure>: ProcessorProtocol {
	let action: (Value) -> ProcessingResult<Value, Failure>
	
	init (_ action: @escaping (Value) -> ProcessingResult<Value, Failure>) {
		self.action = action
	}
	
	func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		action(value)
	}
}

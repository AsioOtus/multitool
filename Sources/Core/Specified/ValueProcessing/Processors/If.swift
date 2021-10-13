struct If <Value, Failure>: ProcessorProtocol {
	static var name: String { "if" }
	
	let condition: (Value) -> Bool
	let thenProcessor: AnyProcessor<Value, Failure>
	let elseProcessor: AnyProcessor<Value, Failure>?
	
	init (_ condition: @escaping (Value) -> Bool, then thenProcessor: AnyProcessor<Value, Failure>, else elseProcessor: AnyProcessor<Value, Failure>? = nil) {
		self.condition = condition
		self.thenProcessor = thenProcessor
		self.elseProcessor = elseProcessor
	}
	
	func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		condition(value) ? thenProcessor.process(value) : (elseProcessor?.process(value) ?? .single(.init(.success(value), If.name)))
	}
}

extension AnyProcessor {
	static func `if` (_ condition: @escaping (Value) -> Bool, _ thenProcessor: AnyProcessor<Value, Failure>, _ elseProcessor: AnyProcessor<Value, Failure>? = nil) -> Self {
		If(condition, then: thenProcessor, else: elseProcessor).eraseToAnyProcessor()
	}
	
	static func `if` (true condition: @escaping (Value) -> Bool, then thenProcessor: AnyProcessor<Value, Failure>, else elseProcessor: AnyProcessor<Value, Failure>? = nil) -> Self {
		If(condition, then: thenProcessor, else: elseProcessor).eraseToAnyProcessor()
	}
}

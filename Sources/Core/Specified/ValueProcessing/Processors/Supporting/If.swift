public struct If <Value, Failure>: ProcessorProtocol {
	public static var name: String { "if" }
	
	public let condition: (Value) -> Bool
	public let thenProcessor: AnyProcessor<Value, Failure>
	public let elseProcessor: AnyProcessor<Value, Failure>?
	
	public init (_ condition: @escaping (Value) -> Bool, then thenProcessor: AnyProcessor<Value, Failure>, else elseProcessor: AnyProcessor<Value, Failure>? = nil) {
		self.condition = condition
		self.thenProcessor = thenProcessor
		self.elseProcessor = elseProcessor
	}
	
	public func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		condition(value) ? thenProcessor.process(value) : (elseProcessor?.process(value) ?? .single(.init(.success(value), If.name)))
	}
}

public extension AnyProcessor {
	static func `if` (_ condition: @escaping (Value) -> Bool, _ thenProcessor: AnyProcessor<Value, Failure>, _ elseProcessor: AnyProcessor<Value, Failure>? = nil) -> Self {
		If(condition, then: thenProcessor, else: elseProcessor).eraseToAnyProcessor()
	}
	
	static func `if` (true condition: @escaping (Value) -> Bool, then thenProcessor: AnyProcessor<Value, Failure>, else elseProcessor: AnyProcessor<Value, Failure>? = nil) -> Self {
		If(condition, then: thenProcessor, else: elseProcessor).eraseToAnyProcessor()
	}
}

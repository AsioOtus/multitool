public struct Custom <Value, Failure>: ProcessorProtocol {
	public let action: (Value) -> ProcessingResult<Value, Failure>
	
	public init (_ action: @escaping (Value) -> ProcessingResult<Value, Failure>) {
		self.action = action
	}
	
	public func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		action(value)
	}
}

public extension AnyProcessor {
	static func custom (_ action: @escaping (Value) -> ProcessingResult<Value, Failure>) -> AnyProcessor {
		Custom(action).eraseToAnyProcessor()
	}
}

public struct Custom <Value, Failure>: ProcessorProtocol {
	public let action: (Value) -> ProcessingResult<Value, Failure>
	
	public init (action: @escaping (Value) -> ProcessingResult<Value, Failure>) {
		self.action = action
	}
	
	public func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		action(value)
	}
}

public extension AnyProcessor {
	static func custom (action: @escaping (Value) -> ProcessingResult<Value, Failure>) -> AnyProcessor {
		Custom(action: action).eraseToAnyProcessor()
	}
}

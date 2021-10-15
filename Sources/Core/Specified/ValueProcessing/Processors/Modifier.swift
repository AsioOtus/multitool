public struct Modifier <Value, Failure>: ProcessorProtocol {
	public static var name: String { "modifier" }
	
	public let label: String?
	
	public let modification: (Value) -> Value
	
	public init (label: String? = nil, modification: @escaping (Value) -> Value) {
		self.label = label
		self.modification = modification
	}
	
	public func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		let modifiedValue = modification(value)		
		return .single(.init(.success(modifiedValue), Self.name, label))
	}
}

public extension AnyProcessor {
	static func modify (label: String? = nil, modification: @escaping (Value) -> Value) -> Self {
		Modifier(label: label, modification: modification).eraseToAnyProcessor()
	}
	
	static func modify (_ modifier: Modifier<Value, Failure>) -> Self {
		modifier.eraseToAnyProcessor()
	}
}

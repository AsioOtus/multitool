extension Derived {
	public enum CreationMode {
		case value(Value)
		case prototype
		case copy
	}
}



public enum Derived<Value> {
	case value(Value)
	case prototype(() -> Value)
	
	public init (from prototype: @escaping @autoclosure () -> Value, mode: CreationMode) {
		switch mode {
		case .value(let value):
			self = .value(value)
		case .prototype:
			self = .prototype(prototype)
		case .copy:
			self = .value(prototype())
		}
	}
	
	public var value: Value {
		switch self {
		case .value(let value):
			return value
		case .prototype(let prototype):
			return prototype()
		}
	}
}



@propertyWrapper
public struct DerivedProperty<Value> {
	public var value: Derived<Value>
	
	public var wrappedValue: Value {
		get {
			switch value {
			case .value(let value):
				return value
			case .prototype(let prototype):
				return prototype()
			}
		}
		set {
			value = .value(newValue)
		}
	}
	
	public var projectedValue: Derived<Value> {
		get { value }
		set { value = newValue }
	}
	
	init (_ value: Derived<Value>) {
		self.value = value
	}
}

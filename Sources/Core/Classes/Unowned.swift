@dynamicMemberLookup
public final class Unowned<Value: AnyObject> {
	public static func unowned (_ value: Value) -> Self {
		.init(value)
	}

	public unowned var value: Value
	
	public init (_ value: Value) {
		self.value = value
	}

	subscript <T> (dynamicMember keyPath: WritableKeyPath<Value, T>) -> T {
		value[keyPath: keyPath]
	}

	subscript <T> (dynamicMember keyPath: KeyPath<Value, T>) -> T {
		value[keyPath: keyPath]
	}
}

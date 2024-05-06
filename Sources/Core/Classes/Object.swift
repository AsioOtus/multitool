@dynamicMemberLookup
public final class Object<Value> {
	public static func object (_ value: Value) -> Self {
		.init(value)
	}

	public var value: Value

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

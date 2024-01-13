@dynamicMemberLookup
public final class Object<Value> {
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

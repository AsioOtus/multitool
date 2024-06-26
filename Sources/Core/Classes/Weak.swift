@dynamicMemberLookup
public final class Weak <Value: AnyObject> {
	public static func weak (_ value: Value) -> Self {
		.init(value)
	}

	public weak var value: Value?
	
	public init (_ value: Value) {
		self.value = value
	}

	subscript <T> (dynamicMember keyPath: WritableKeyPath<Value, T>) -> T? {
		value?[keyPath: keyPath]
	}

	subscript <T> (dynamicMember keyPath: KeyPath<Value, T>) -> T? {
		value?[keyPath: keyPath]
	}
}

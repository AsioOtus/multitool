@dynamicMemberLookup
public final class Unowned <ReferencedValue: AnyObject> {
	public static func unowned (_ value: ReferencedValue) -> Self {
		.init(value)
	}

	public unowned var referencedValue: ReferencedValue

	public init (_ referencedValue: ReferencedValue) {
		self.referencedValue = referencedValue
	}

    public subscript <T> (dynamicMember keyPath: WritableKeyPath<ReferencedValue, T>) -> T {
		referencedValue[keyPath: keyPath]
	}

    public subscript <T> (dynamicMember keyPath: KeyPath<ReferencedValue, T>) -> T {
		referencedValue[keyPath: keyPath]
	}
}

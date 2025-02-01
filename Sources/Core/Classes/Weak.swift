@dynamicMemberLookup
public final class Weak <ReferencedValue: AnyObject> {
	public static func weak (_ value: ReferencedValue) -> Self {
		.init(value)
	}

	public weak var referencedValue: ReferencedValue?

	public init (_ referencedValue: ReferencedValue?) {
		self.referencedValue = referencedValue
	}

	public subscript <T> (dynamicMember keyPath: WritableKeyPath<ReferencedValue, T>) -> T? {
		referencedValue?[keyPath: keyPath]
	}

    public subscript <T> (dynamicMember keyPath: KeyPath<ReferencedValue, T>) -> T? {
		referencedValue?[keyPath: keyPath]
	}
}

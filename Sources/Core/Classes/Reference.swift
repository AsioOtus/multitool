@dynamicMemberLookup
public final class Reference <ReferencedValue> {
	public static func reference (_ value: ReferencedValue) -> Self {
		.init(value)
	}

	public var referencedValue: ReferencedValue

	public init (_ value: ReferencedValue) {
		self.referencedValue = value
	}

	public subscript <T> (dynamicMember keyPath: WritableKeyPath<ReferencedValue, T>) -> T {
		referencedValue[keyPath: keyPath]
	}

    public subscript <T> (dynamicMember keyPath: KeyPath<ReferencedValue, T>) -> T {
		referencedValue[keyPath: keyPath]
	}
}

@propertyWrapper
public final class ReferencedProperty <ReferencedValue> {
    public var reference: Reference<ReferencedValue>

    public var wrappedValue: ReferencedValue {
        get {
            reference.referencedValue
        }
        set {
            reference.referencedValue = newValue
        }
    }

    public var projectedValue: Reference<ReferencedValue> {
        get { reference }
        set { reference = newValue }
    }

    public init (wrappedValue referencedValue: ReferencedValue) {
        self.reference = .init(referencedValue)
    }

    public convenience init (_ referencedValue: ReferencedValue) {
        self.init(wrappedValue: referencedValue)
    }
}

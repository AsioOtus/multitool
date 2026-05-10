public protocol HashableObject: AnyObject, Hashable { }

public extension HashableObject {
	static func == (lhs: Self, rhs: Self) -> Bool {
		ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
	}

	func hash (into hasher: inout Hasher) {
		hasher.combine(ObjectIdentifier(self))
	}
}

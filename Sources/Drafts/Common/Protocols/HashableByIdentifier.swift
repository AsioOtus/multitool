public protocol HashableByIdentifier: Hashable, Identifiable { }

public extension HashableByIdentifier where Self.Identifier: BinaryInteger {
	var hashValue: Int {
		return Int(id)
	}
	
	static func == (_ left: Self, _ right: Self) -> Bool {
		return left.id == right.id
	}
}

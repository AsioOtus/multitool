public extension Sequence where Element: Hashable {
	func duplicatesRemoved () -> [Element] {
		var unique = Set<Element>()
		return filter { unique.insert($0).0 }
	}
}

public extension Sequence {
	func duplicatesRemoved <T: Hashable> (_ property: KeyPath<Element, T>) -> [Element] {
		var unique = Set<T>()
		return filter { unique.insert($0[keyPath: property]).0 }
	}
}

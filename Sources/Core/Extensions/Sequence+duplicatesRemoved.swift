public extension Sequence where Element: Hashable {
	func duplicatesRemoved () -> [Element] {
		var unique = Set<Element>()
		return filter { unique.insert($0).0 }
	}
}

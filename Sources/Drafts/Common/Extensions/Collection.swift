public extension Collection where Element: Equatable {
	static func ~= (array: Self, value: Element) -> Bool {
		return array.contains(value)
	}
}

public extension Collection where Indices.Iterator.Element == Index {
	subscript (safe index: Index) -> Iterator.Element? {
		return indices.contains(index) ? self[index] : nil
	}
}

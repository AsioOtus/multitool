public extension Collection where Element: Equatable {
	static func ~= (array: Self, value: Element) -> Bool {
		return array.contains(value)
	}
}

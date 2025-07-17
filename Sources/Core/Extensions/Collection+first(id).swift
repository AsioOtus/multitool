public extension Collection where Element: Identifiable {
	func first (id: Element.ID) -> Element? {
		first { $0.id == id }
	}
}

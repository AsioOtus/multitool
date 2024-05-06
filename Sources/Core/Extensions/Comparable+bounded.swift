public extension Comparable {
	func bounded (_ lowerBound: Self, _ upperBound: Self) -> Self {
		min(max(self, lowerBound), upperBound)
	}
}

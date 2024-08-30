public protocol CaseCheckable {
	func `is` (oneOf cases: Self...) -> Bool
}

public extension CaseCheckable where Self: Hashable {
	func `is` (oneOf cases: Self...) -> Bool {
		cases.contains(self)
	}

	func `is` (oneOf cases: Set<Self>) -> Bool {
		cases.contains(self)
	}
}

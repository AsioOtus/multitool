public protocol CreatableByInt { }

public extension CreatableByInt where Self: CaseIterable {
	init (int: Int) {
		let normilizedInt = int % Self.allCases.count
		let resultDirection = Self.allCases[Self.allCases.index(Self.allCases.startIndex, offsetBy: normilizedInt)]
		self = resultDirection
	}
}

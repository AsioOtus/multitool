public protocol RandomableElement: Collection where Index == Int { }

public extension RandomableElement {
	var randomElement: Self.Element? {
		guard count != 0 else { return nil }
		
		let randomElement = self[Int.random(in: 0..<count)]
		return randomElement
	}
}

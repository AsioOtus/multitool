public extension Array {
	static func + (left: Array, right: Element) -> Array {
		return left + [right]
	}
	
	static func + (left: Element, right: Array) -> Array {
		return [left] + right
	}
	
	static func += (left: inout Array, right: Element) {
		left.append(right)
	}
}

extension Set {
	public static func + (left: Set, right: Element) -> Set {
		var newSet = left
		newSet.insert(right)
		return newSet
	}
	
	public static func += (left: inout Set, right: Element) {
		left.insert(right)
	}
}

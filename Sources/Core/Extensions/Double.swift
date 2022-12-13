public extension Double {
	var asInt: Int? {
		self >= Double(Int.min) && self < Double(Int.max)
		? Int(self)
		: nil
	}
}

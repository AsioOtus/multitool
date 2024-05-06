public extension Double {
	var safeInt: Int? {
		self >= Double(Int.min) && self < Double(Int.max)
			? Int(self)
			: nil
	}
}

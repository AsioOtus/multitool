public extension FixedWidthInteger {
	func rotate (by offset: Int) -> Self {
		rotate(by: offset, modulus: UInt(MemoryLayout<Self>.size * 8))
	}

	func rotate (by offset: Int, modulus: UInt) -> Self {
		let isNegativeOffset = offset < 0
		let modulus = Int(modulus)
		let offset = abs(offset)

		var right = offset % modulus
		var left = abs(modulus - right)

		if isNegativeOffset {
			(left, right) = (right, left)
		}

		let l = self >> left
		let r = self << right

		let result = l | r
		let mask = Self((1 << modulus) - 1)

		return result & mask
	}
}

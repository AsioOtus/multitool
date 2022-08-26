import Foundation

public extension FixedWidthInteger {
	func rotateLeft (_ shift: Int) -> Self {
		let valueBitsCount = MemoryLayout<Self>.size * 8
		let shiftModulus = shift % valueBitsCount
		return (self << shiftModulus) | (self >> (valueBitsCount - shiftModulus))
	}
	
	func rotateRight (_ shift: Int) -> Self {
		let valueBitsCount = MemoryLayout<Self>.size * 8
		let shiftModulus = shift % valueBitsCount
		return (self >> shiftModulus) | (self << (valueBitsCount - shiftModulus))
	}
	
	static func <<> (_ value: Self, _ shift: Int) -> Self {
		value.rotateLeft(shift)
	}
	
	static func <>> (_ value: Self, _ shift: Int) -> Self {
		value.rotateRight(shift)
	}
}

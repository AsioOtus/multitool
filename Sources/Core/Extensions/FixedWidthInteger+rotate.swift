import Foundation

public extension FixedWidthInteger {
	func rotateLeft (_ shift: Int, modulus: Int? = nil) -> Self {
		let valueBitsCount = modulus ?? MemoryLayout<Self>.size * 8
		let shiftModulus = shift % valueBitsCount
		return (self << shiftModulus) | (self >> (valueBitsCount - shiftModulus))
	}
	
	func rotateRight (_ shift: Int, modulus: Int? = nil) -> Self {
		let valueBitsCount = modulus ?? MemoryLayout<Self>.size * 8
		let shiftModulus = shift % valueBitsCount
		return (self >> shiftModulus) | (self << (valueBitsCount - shiftModulus))
	}
}

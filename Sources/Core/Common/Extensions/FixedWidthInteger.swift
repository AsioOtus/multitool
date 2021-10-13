import Foundation



public extension FixedWidthInteger {
	var digitsCount: Int {
		get {
			func numberOfDigits(in number: Self) -> Int {
				var result = 1
				
				if number >= 10 || number <= -10 {
					result += numberOfDigits(in: number / 10)
				}
				
				return result
			}
			
			return numberOfDigits(in: self)
		}
	}
	
	var isEven: Bool {
		return self % 2 == 0
	}
	
	var isOdd: Bool {
		return self % 2 != 0
	}
}
	


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



public extension FixedWidthInteger {
	var binRadix: String {
		return String(self, radix: 2)
	}
	
	var octRadix: String {
		return String(self, radix: 8)
	}
	
	var decRadix: String {
		return String(self, radix: 10)
	}
	
	var hexRadix: String {
		return String(self, radix: 16)
	}
}

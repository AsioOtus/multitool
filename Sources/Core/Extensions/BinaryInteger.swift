import Foundation

public extension BinaryInteger {
	var digitsCount: Int {
        func numberOfDigits (in number: Self) -> Int {
            var result = 1
            
            if number >= 10 || number <= -10 {
                result += numberOfDigits(in: number / 10)
            }
            
            return result
        }
        
        return numberOfDigits(in: self)
	}
	
	var isEven: Bool { self % 2 == 0 }
	var isOdd: Bool { self % 2 != 0 }
}

public extension BinaryInteger {
	var binRadix: String { String(self, radix: 2) }
	var octRadix: String { String(self, radix: 8) }
	var decRadix: String { String(self, radix: 10) }
	var hexRadix: String { String(self, radix: 16) }
}

public extension BinaryInteger {
	var data: Data {
		var int = self
		return Data(bytes: &int, count: MemoryLayout<Self>.size)
	}
}

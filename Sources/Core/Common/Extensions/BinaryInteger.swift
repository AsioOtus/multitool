import Foundation

public extension BinaryInteger {
	var binRadix: String {
		String(self, radix: 2)
	}
	
	var octRadix: String {
		String(self, radix: 8)
	}
	
	var decRadix: String {
		String(self, radix: 10)
	}
	
	var hexRadix: String {
		String(self, radix: 16)
	}
}

public extension BinaryInteger {
	var data: Data {
		var int = self
		return Data(bytes: &int, count: MemoryLayout<Self>.size)
	}
}

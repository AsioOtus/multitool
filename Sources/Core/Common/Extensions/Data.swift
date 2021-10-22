import Foundation

public extension Data {
	init? (hex: String) {
		guard !hex.isHex else { return nil }
				
		let bytesStrings = hex.divide(fromEndBy: 2)
		var bytes = [UInt8]()
		
		for byteString in bytesStrings {
			guard let byte = UInt8(byteString, radix: 16) else { return nil }
			bytes.append(byte)
		}
		
		self.init(bytes)
	}
}

public extension Data {
	var bin: String {
		map { String($0, radix: 2).padded(atStartTo: 8, with: "0") }.joined(separator: " ")
	}
	
	var oct: String {
		map { String($0, radix: 8).padded(atStartTo: 3, with: "0") }.joined(separator: " ")
	}
	
	var dec: String {
		map { String($0, radix: 10) }.joined(separator: " ")
	}
	
	var hex: String {
		map { String($0, radix: 16).padded(atStartTo: 2, with: "0") }.joined(separator: " ")
	}
	
	
	
	var plainBin: String {
		map { String($0, radix: 2) }.joined()
	}
	
	var plainOct: String {
		map { String($0, radix: 8) }.joined()
	}
	
	var plainDec: String {
		map { String($0, radix: 10) }.joined()
	}
	
	var plainHex: String {
		map { String($0, radix: 16) }.joined()
	}
	
	
	
	var prefixedBin: String {
		map { String($0, radix: 2).padded(atStartTo: 8, with: "0") }.map{ "0b\($0)" }.joined(separator: " ")
	}
	
	var prefixedOct: String {
		map { String($0, radix: 8).padded(atStartTo: 3, with: "0") }.map{ "0o\($0)" }.joined(separator: " ")
	}
	
	var prefixedDec: String {
		map { String($0, radix: 10) }.map{ "0d\($0)" }.joined(separator: " ")
	}
	
	var prefixedHex: String {
		map { String($0, radix: 16).padded(atStartTo: 2, with: "0") }.map{ "0x\($0)" }.joined(separator: " ")
	}
}

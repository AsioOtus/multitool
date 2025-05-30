import Foundation

public extension String {
	static let defaultGroupSeparator = " "

	func grouped (fromStartBy groupSize: Int, with separator: String = defaultGroupSeparator) -> String {
		return self.divide(fromStartBy: groupSize).joined(separator: separator)
	}

	func grouped (fromEndBy groupSize: Int, with separator: String = defaultGroupSeparator) -> String {
		return self.divide(fromEndBy: groupSize).joined(separator: separator)
	}
	
	func divide (fromStartBy groupSize: Int) -> [String] {
		return self.divide(by: groupSize)
	}
	
	func divide (fromEndBy groupSize: Int) -> [String] {
		return String(self.reversed()).divide(by: groupSize).map{ $0.reversed }.reversed()
	}
	
	private func divide (by groupSize: Int) -> [String] {
		guard groupSize > 0 else { return [self] }
		
		var i = 0
		var groupString = ""
		var resultArray = [String]()
		
		for character in self {
			if i == groupSize {
				resultArray += [groupString]
				
				groupString = ""
				i = 0
			}
			
			groupString += String(character)
			i += 1
		}
		
		if groupString != "" {
			resultArray += [groupString]
		}
		
		return resultArray
	}
}

public extension String {
	var reversed: String {
		return String(self.reversed())
	}
}

public extension String {
	subscript (safe offset: Int) -> Character? {
		guard let resultIndex = self.index(self.startIndex, offsetBy: offset, limitedBy: self.endIndex) else { return nil }
		return self[resultIndex]
	}
	
	func index (at offset: Int) -> String.Index? {
		index(startIndex, offsetBy: offset, limitedBy: endIndex)
	}

	func indexOrEnd (at offset: Int) -> String.Index {
		index(at: offset) ?? self.endIndex
	}

	func offset (of index: String.Index) -> Int {
		distance(from: startIndex, to: index)
	}
	
	func offset (of substring: String) -> Int? {
		guard let substringIndex = self.range(of: substring)?.lowerBound else { return nil }
		return offset(of: substringIndex)
	}
}

public extension String {
	var base64Encoded: String {
		let encodedString = self.data(using: .utf8)!.base64EncodedString()
		return encodedString
	}
	
	var base64Decoded: String? {
		guard let stringData = Data(base64Encoded: self) else { return nil }
		let decodedString = String(data: stringData, encoding: .utf8)
		return decodedString
	}
	
	init? (fromBase64 string: String) {
		guard let decodedString = string.base64Decoded else { return nil }
		self = decodedString
	}
	
	init? (toBase64 string: String) {
		self = string.base64Encoded
	}
}

public extension String {
	var isHex: Bool {
		let isHex = self.allSatisfy{ $0.isHexDigit }
		return isHex
	}
}

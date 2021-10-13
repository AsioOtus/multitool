public protocol DataStringRepresentable {
	var plainBin: String { get }
	var bin: String { get }
	
	var plainOct: String { get }
	var oct: String { get }
	
	var plainDec: String { get }
	var dec: String { get }
	
	var plainHex: String { get }
	var hex: String { get }
}

extension DataStringRepresentable {
	public var bin: String {
		return plainBin.grouped(fromEndBy: 8)
	}
	
	public var oct: String {
		return plainOct.grouped(fromEndBy: 4)
	}
	
	public var dec: String {
		return plainDec.grouped(fromEndBy: 3)
	}
	
	public var hex: String {
		return plainHex.grouped(fromEndBy: 2)
	}
}

import Foundation

extension DigitDataStringConverter {
	public enum Radix {
		case bin, oct, dec, hex
		
		public var format: String {
			let format: String
			
			switch self {
			case .bin:
				format = "%02b"
			case .oct:
				format = "%02dx"
			case .dec:
				format = "%02o"
			case .hex:
				format = "%02hx"
			}
			
			return format
		}
	}
}

public struct DigitDataStringConverter: DataStringConverter {
	public static let `default` = Self()
	
	public var radix: Radix
	public var separator: String
	
	public init (radix: Radix = .hex, separator: String? = " ") {
		self.radix = radix
		self.separator = separator ?? ""
	}
	
	public func convert (_ data: Data) -> String {
		return data.map{ String(format: radix.format, $0) }.joined(separator: separator)
	}
}

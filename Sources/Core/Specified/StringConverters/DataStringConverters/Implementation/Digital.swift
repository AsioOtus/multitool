import Foundation

extension DataStringConverters.Digital {
	public enum Radix: Int {
		case bin = 2
		case oct = 8
		case dec = 10
		case hex = 16
		
		public var prefix: String {
			switch self {
			case .bin:
				return "0b"
			case .oct:
				return "0o"
			case .dec:
				return "0d"
			case .hex:
				return "0x"
			}
		}
	}
}

extension DataStringConverters {
	public struct Digital: DataStringConverter {
		public static let `default` = Self()
		
		public var radix: Radix
		public var prefixed: Bool
		public var separator: String
		
		public init (radix: Radix = .hex, prefixed: Bool = false, separator: String = " ") {
			self.radix = radix
			self.prefixed = prefixed
			self.separator = separator
		}
		
		public func convert (_ data: Data) -> String {
			return data.map{ String($0, radix: radix.rawValue) }.map{ prefixed ? radix.prefix : "" + $0 }.joined(separator: separator)
		}
	}
}

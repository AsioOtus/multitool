import Foundation

public struct RawDataStringConverter: OptionalDataStringConverter {
	public static let `default` = Self()
    
	public var encoding: String.Encoding
    
	public init (encoding: String.Encoding = .utf8) {
        self.encoding = encoding
    }
    
	public func convert (_ data: Data) -> String? {
        String(data: data, encoding: encoding)
    }
}

import Foundation

extension DataStringConverters {
	public struct Base64: DataStringConverter {
		public static let `default` = Self()
		
		public var options: Data.Base64EncodingOptions
		
		public init (options: Data.Base64EncodingOptions = []) {
			self.options = options
		}
		
		public func convert (_ data: Data) -> String {
			data.base64EncodedString(options: options)
		}
	}
}

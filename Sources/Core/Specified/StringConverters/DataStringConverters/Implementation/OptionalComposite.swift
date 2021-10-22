import Foundation

extension DataStringConverters {
	public struct OptionalComposite: OptionalDataStringConverter {
		public static let `default` = Self(
			converters: [
				DataStringConverters.JSON.default,
				DataStringConverters.Text.default,
				DataStringConverters.Base64.default
			]
		)
		
		public var converters: [OptionalDataStringConverter]
		
		public init (converters: [OptionalDataStringConverter]) {
			self.converters = converters
		}
		
		public func convert (_ data: Data) -> String? {
			for converter in converters {
				if let string = converter.convert(data) {
					return string
				}
			}
			
			return nil
		}
	}
}

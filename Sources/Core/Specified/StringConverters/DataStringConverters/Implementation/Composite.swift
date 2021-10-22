import Foundation

extension DataStringConverters {
	public struct Composite: DataStringConverter {
		public static let `default` = Self(
			converters: [
				DataStringConverters.JSON.default,
				DataStringConverters.Text.default
			],
			lastResortConverter: DataStringConverters.Base64.default
		)
		
		public var converters: [OptionalDataStringConverter]
		public var lastResortConverter: DataStringConverter
		
		public init (converters: [OptionalDataStringConverter], lastResortConverter: DataStringConverter) {
			self.converters = converters
			self.lastResortConverter = lastResortConverter
		}
		
		public func convert (_ data: Data) -> String {
			for converter in converters {
				if let string = converter.convert(data) {
					return string
				}
			}
			
			let string = lastResortConverter.convert(data)
			return string
		}
	}
}

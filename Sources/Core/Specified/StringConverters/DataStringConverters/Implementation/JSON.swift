import Foundation

extension DataStringConverters {
	public struct JSON: OptionalDataStringConverter {
		public static let `default` = Self()
		
		private let options: JSONSerialization.WritingOptions
		
		public init (options: JSONSerialization.WritingOptions = [.prettyPrinted]) {
			self.options = options
		}
		
		public func convert (_ data: Data) -> String? {
			guard
				let object = try? JSONSerialization.jsonObject(with: data, options: []),
				let data = try? JSONSerialization.data(withJSONObject: object, options: options),
				let string = String(data: data, encoding: .utf8)
			else { return nil }
			
			return string
		}
	}
}

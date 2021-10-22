import Foundation

extension URLResponseStringConverters {
	public struct Default: URLResponseStringConverter {
		public static let `default` = Self()
		
		public let dataStringConverter: OptionalDataStringConverter
		public let dictionaryStringConverter: DictionaryStringConverter
		
		public init (
			dataStringConverter: OptionalDataStringConverter = DataStringConverters.OptionalComposite.default,
			dictionaryStringConverter: DictionaryStringConverter = DictionaryStringConverters.Multiline.default
		) {
			self.dataStringConverter = dataStringConverter
			self.dictionaryStringConverter = dictionaryStringConverter
		}
		
		public func convert (_ urlResponse: URLResponse, body: Data?) -> String {
			var components = [String]()
			
			let firstLine = SingleLine().convert(urlResponse, body: body)
			components.append(firstLine)
			
			components.append("")
			
			if let body = body {
				if let bodyString = dataStringConverter.convert(body), !bodyString.isEmpty {
					components.append(bodyString)
				} else {
					components.append("[Body representation is empty]")
				}
			} else {
				components.append("[No body]")
			}
			
			let string = components.joined(separator: "\n")
			return string
		}
	}
}

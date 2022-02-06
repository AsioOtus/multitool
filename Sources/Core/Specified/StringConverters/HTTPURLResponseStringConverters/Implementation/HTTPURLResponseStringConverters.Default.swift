import Foundation

extension HTTPURLResponseStringConverters {
	public struct Default: HTTPURLResponseStringConverter {
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
		
		public func convert (_ httpUrlResponse: HTTPURLResponse, body: Data? = nil) -> String {
			var components = [String]()
			
			let firstLine = ShortSingleLine().convert(httpUrlResponse, body: body)
			components.append(firstLine)
			
			components.append("")
			
			if !httpUrlResponse.allHeaderFields.isEmpty {
				let headers = dictionaryStringConverter.convert(httpUrlResponse.allHeaderFields)
				
				if !headers.isEmpty {
					components.append(headers)
				} else {
					components.append("[Header representation is empty]")
				}
			} else {
				components.append("[No headers]")
			}
			
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

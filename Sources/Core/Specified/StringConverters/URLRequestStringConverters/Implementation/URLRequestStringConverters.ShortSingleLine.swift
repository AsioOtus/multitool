import Foundation

extension URLRequestStringConverters {
	public struct ShortSingleLine: URLRequestStringConverter {
		public init () { }
		
		public func convert (_ urlRequest: URLRequest) -> String {
			let string = "\(urlRequest.httpMethod ?? "[No method]") – \(urlRequest.url?.absoluteString ?? "[No URL]")"
			return string
		}
	}
}

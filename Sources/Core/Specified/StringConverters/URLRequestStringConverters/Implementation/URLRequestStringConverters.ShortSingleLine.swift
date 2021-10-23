import Foundation

extension URLRequestStringConverters {
	public struct ShortSingleLine: URLRequestStringConverter {
		public func convert (_ urlRequest: URLRequest) -> String {
			let string = "\(urlRequest.httpMethod ?? "[No method]") – \(urlRequest.url?.absoluteString ?? "[No URL]")"
			return string
		}
	}
}

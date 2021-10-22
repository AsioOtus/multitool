import Foundation

extension URLRequestStringConverters {
	public struct SingleLine: URLRequestStringConverter {
		public func convert (_ urlRequest: URLRequest) -> String {
			let string = "\(urlRequest.httpMethod ?? "[No method]") – \(urlRequest.url?.absoluteString ?? "[No URL]")"
			return string
		}
	}
}

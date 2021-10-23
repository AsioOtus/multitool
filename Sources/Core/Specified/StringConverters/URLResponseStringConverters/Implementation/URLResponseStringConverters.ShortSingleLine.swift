import Foundation

extension URLResponseStringConverters {
	public struct ShortSingleLine: URLResponseStringConverter {
		public func convert (_ urlResponse: URLResponse, body: Data?) -> String {
			let string = urlResponse.url?.absoluteString ?? "[No URL]"
			return string
		}
	}
}

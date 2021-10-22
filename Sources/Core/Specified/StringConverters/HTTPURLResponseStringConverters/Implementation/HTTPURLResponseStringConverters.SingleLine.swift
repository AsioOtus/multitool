import Foundation

extension HTTPURLResponseStringConverters {
	public struct SingleLine: HTTPURLResponseStringConverter {
		public func convert (_ httpUrlResponse: HTTPURLResponse, body: Data?) -> String {
			let string = "\(httpUrlResponse.url?.absoluteString ?? "[No URL]") – \(httpUrlResponse.statusCode)"
			return string
		}
	}
}

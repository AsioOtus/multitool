import Foundation

public struct ShortURLRequestStringConverter: URLRequestStringConverter {
	public func convert (_ urlRequest: URLRequest) -> String {
		let string = "\(urlRequest.httpMethod ?? "[No method]") – \(urlRequest.url?.absoluteString ?? "[No URL]")"
		return string
	}
}

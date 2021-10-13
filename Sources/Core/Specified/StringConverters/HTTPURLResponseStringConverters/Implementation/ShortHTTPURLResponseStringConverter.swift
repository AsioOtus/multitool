import Foundation

public struct ShortHTTPURLResponseStringConverter: HTTPURLResponseStringConverter {
	public func convert (_ httpUrlResponse: HTTPURLResponse, body: Data?) -> String {
        let string = "\(httpUrlResponse.url?.absoluteString ?? "[No URL]") – \(httpUrlResponse.statusCode)"
        return string
    }
}

import Foundation

public protocol URLResponseStringConverter {
	func convert (_ urlResponse: URLResponse, body: Data?) -> String
}

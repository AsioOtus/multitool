import Foundation

public protocol URLRequestStringConverter {
	func convert (_ urlRequest: URLRequest) -> String
}

import Foundation

public protocol ArrayStringConverter {
	func convert <T> (_ dictionary: Array<T>) -> String
}

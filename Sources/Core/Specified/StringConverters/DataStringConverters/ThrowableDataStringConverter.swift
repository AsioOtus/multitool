import Foundation

public protocol ThrowableDataStringConverter: OptionalDataStringConverter {
	func tryConvert (_ data: Data) throws -> String
}

public extension ThrowableDataStringConverter {
	func convert (_ data: Data) -> String? {
		try? tryConvert(data)
	}
}

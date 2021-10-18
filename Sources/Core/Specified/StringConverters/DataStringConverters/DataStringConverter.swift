import Foundation

public protocol DataStringConverter: ThrowableDataStringConverter {
    func convert (_ data: Data) -> String
}

public extension DataStringConverter {	
	func tryConvert (_ data: Data) throws -> String {
		convert(data)
	}
}

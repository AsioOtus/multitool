import Foundation

public protocol DataStringConverter: OptionalDataStringConverter {
    func convert (_ data: Data) -> String
}

public extension DataStringConverter {
    func convert (_ data: Data) -> String? {
        let string: String = convert(data)
        return string
    }
}

import Foundation

public protocol OptionalDataStringConverter {
    func convert (_ data: Data) -> String?
}

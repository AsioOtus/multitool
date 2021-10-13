import Foundation

public protocol DictionaryStringConverter {
    func convert (_ dictionary: Dictionary<AnyHashable, Any>) -> String
}

import Foundation

public struct MultilineDictionaryStringConverter: DictionaryStringConverter {
	public static let `default` = Self()
    
	public func convert (_ dictionary: Dictionary<AnyHashable, Any>) -> String {
        dictionary.map{ "\($0.key): \($0.value)" }.joined(separator: "\n")
    }
}

import Foundation

extension DictionaryStringConverters {
	public struct Multiline: DictionaryStringConverter {
		public static let `default` = Self()
		
		public func convert (_ dictionary: Dictionary<AnyHashable, Any>) -> String {
			dictionary.map{ "\($0.key): \($0.value)" }.joined(separator: "\n")
		}
	}
}

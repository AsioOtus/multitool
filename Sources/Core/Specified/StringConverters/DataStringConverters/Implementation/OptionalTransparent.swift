import Foundation

extension DataStringConverters {
	public struct OptionalTransparent: OptionalDataStringConverter {
		public static let `default` = Self()
		
		public init () { }
		
		public func convert (_ data: Data) -> String? { nil }
	}
}

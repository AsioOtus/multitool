import Foundation

public extension Numeric {
	func grouped (with separator: String = " ", as style: NumberFormatter.Style) -> String? {
		let formatter = NumberFormatter()
		formatter.groupingSeparator = separator
		formatter.numberStyle = style
		
		return formatter.string(for: self) ?? nil
	}
}

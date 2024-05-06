import Foundation

public extension Double {
	func rounded (
		decimalPrecision: Int,
		rule: FloatingPointRoundingRule = .towardZero
	) -> Self {
		let multiplier = pow(10, Double(decimalPrecision))
		return (self * multiplier).rounded(rule) / multiplier
	}
}

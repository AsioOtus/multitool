public struct RGBA {
	public let red: Double
	public let green: Double
	public let blue: Double
	public let alpha: Double

	public init (
		red: Double,
		green: Double,
		blue: Double,
		alpha: Double = 1
	) {
		self.red = red
		self.green = green
		self.blue = blue
		self.alpha = alpha
	}
}

public extension RGBA {
	func random () -> Self {
		.init(
			red: .random(in: 0...1),
			green: .random(in: 0...1),
			blue: .random(in: 0...1),
			alpha: .random(in: 0...1)
		)
	}
}

extension RGBA: Codable, Hashable { }

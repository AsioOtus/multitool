public struct HSBA: Codable, Hashable {
	public let hue: Double
	public let saturation: Double
	public let brightness: Double
	public let alpha: Double

	public init (
		hue: Double,
		saturation: Double,
		brightness: Double,
		alpha: Double = 1
	) {
		self.hue = hue
		self.saturation = saturation
		self.brightness = brightness
		self.alpha = alpha
	}
}

public extension HSBA {
	func adjust (
		hue: Double = 0,
		saturation: Double = 0,
		brightness: Double = 0,
		alpha: Double = 0
	) -> Self {
		func adjust (_ value: Double, _ multiplier: Double) -> Double {
			min(value + value * multiplier, 1)
		}
		
		return .init(
			hue: adjust(self.hue, hue),
			saturation: adjust(self.saturation, saturation),
			brightness: adjust(self.brightness, brightness),
			alpha: adjust(self.alpha, alpha)
		)
	}
}

import Foundation

public struct HSBA: Codable, Hashable  {
	public static let black = Self(hue: 0, saturation: 0, brightness: 0)
	public static let white = Self(hue: 1, saturation: 1, brightness: 1)
	public static let transparent = Self(hue: 0, saturation: 0, brightness: 0, alpha: 0)

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

public extension HSBA {
	static func rgba (
		hue: Double,
		saturation: Double,
		brightness: Double,
		alpha: Double
	) -> RGBA {
		guard saturation != 0 else {
			return .init(
				red: brightness,
				green: brightness,
				blue: brightness,
				alpha: alpha
			)
		}

		let angle = (hue >= 360 ? 0 : hue)
		let sector = angle / 60
		let i = floor(sector)
		let f = sector - i

		let p = brightness * (1 - saturation)
		let q = brightness * (1 - (saturation * f))
		let t = brightness * (1 - (saturation * (1 - f)))

		return switch(i) {
		case 0:
				.init(red: brightness, green: t, blue: p, alpha: alpha)
		case 1:
				.init(red: q, green: brightness, blue: p, alpha: alpha)
		case 2:
				.init(red: p, green: brightness, blue: t, alpha: alpha)
		case 3:
				.init(red: p, green: q, blue: brightness, alpha: alpha)
		case 4:
				.init(red: t, green: p, blue: brightness, alpha: alpha)
		default:
				.init(red: brightness, green: p, blue: q, alpha: alpha)
		}
	}

	static func rgba (hsba: HSBA) -> RGBA {
		rgba(
			hue: hsba.hue,
			saturation: hsba.saturation,
			brightness: hsba.brightness,
			alpha: hsba.alpha
		)
	}

	var rgba: RGBA {
		HSBA.rgba(hsba: self)
	}
}

public struct RGBA: Codable, Hashable {
	public static let black = Self(red: 0, green: 0, blue: 0)
	public static let white = Self(red: 1, green: 1, blue: 1)
	public static let transparent = Self(red: 0, green: 0, blue: 0, alpha: 0)

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

public extension RGBA {
	static func hsba (
		red: Double,
		green: Double,
		blue: Double,
		alpha: Double
	) -> HSBA {
		let min = red < green ? (red < blue ? red : blue) : (green < blue ? green : blue)
		let max = red > green ? (red > blue ? red : blue) : (green > blue ? green : blue)

		let brightness = max
		let delta = max - min

		guard delta > 0.00001 else { return .init(hue: 0, saturation: 0, brightness: max, alpha: alpha) }
		guard max > 0 else { return .init(hue: -1, saturation: 0, brightness: brightness, alpha: alpha) }

		let saturation = delta / max

		let hueCalculation: (Double, Double) -> Double = { max, delta -> Double in
			if red == max {
				(green - blue) / delta
			} else if green == max {
				2 + (blue - red) / delta
			} else {
				4 + (red - green) / delta
			}
		}

		let hue = hueCalculation(max, delta) * 60
		let adjustedHue = (hue < 0 ? hue + 360 : hue)

		return .init(hue: adjustedHue, saturation: saturation, brightness: brightness, alpha: alpha)
	}

	static func hsba (rgba: RGBA) -> HSBA {
		hsba(
			red: rgba.red,
			green: rgba.green,
			blue: rgba.blue,
			alpha: rgba.alpha
		)
	}

	var hsba: HSBA {
		RGBA.hsba(rgba: self)
	}
}

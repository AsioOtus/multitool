import Foundation

public struct HSVA: Codable, Hashable  {
	public static let black = Self(a: 1)
	public static let white = Self(h: 1, s: 1, v: 1)
	public static let transparent = Self(a: 0)

	public let hue: Double
	public let saturation: Double
	public let value: Double
	public let alpha: Double

	public init (
		hue: Double = 0,
		saturation: Double = 0,
		value: Double = 0,
		alpha: Double = 1
	) {
		self.hue = hue
		self.saturation = saturation
		self.value = value
		self.alpha = alpha
	}

	public init (
		h: Double = 0,
		s: Double = 0,
		v: Double = 0,
		a: Double = 1
	) {
		self.init(
			hue: h,
			saturation: s,
			value: v,
			alpha: a
		)
	}
}

public extension HSVA {
	var rawDescription: String { "\(hue) \(saturation) \(value) \(alpha)" }
}

public extension HSVA {
	func adjust (
		hue: Double = 0,
		saturation: Double = 0,
		value: Double = 0,
		alpha: Double = 0
	) -> Self {
		func adjust (_ value: Double, _ multiplier: Double) -> Double {
			min(value + value * multiplier, 1)
		}

		return .init(
			hue: adjust(self.hue, hue),
			saturation: adjust(self.saturation, saturation),
			value: adjust(self.value, value),
			alpha: adjust(self.alpha, alpha)
		)
	}
}

public extension HSVA {
	static func rgba (
		hue h: Double,
		saturation s: Double,
		value v: Double,
		alpha: Double
	) -> RGBA {
		let i = floor(h * 6);
		let f = h * 6 - i;
		let p = v * (1 - s);
		let q = v * (1 - f * s);
		let t = v * (1 - (1 - f) * s);

		return switch (Int(i) % 6){
		case 0: .init(r: v, g: t, b: p, a: alpha)
		case 1: .init(r: q, g: v, b: p, a: alpha)
		case 2: .init(r: p, g: v, b: t, a: alpha)

		case 3: .init(r: p, g: q, b: v, a: alpha)
		case 4: .init(r: t, g: p, b: v, a: alpha)
		case 5: .init(r: v, g: p, b: q, a: alpha)
		default: .init(r: v, g: p, b: q, a: alpha)
		}
	}

	static func rgba (hsba: HSVA) -> RGBA {
		rgba(
			hue: hsba.hue,
			saturation: hsba.saturation,
			value: hsba.value,
			alpha: hsba.alpha
		)
	}

	var rgba: RGBA {
		HSVA.rgba(hsba: self)
	}
}

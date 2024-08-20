public extension FloatingPoint {
	func scaled (min: Self, max: Self, newMin: Self, newMax: Self) -> Self {
		newMin + ((self - min) * (newMax - newMin)) / (max - min)
	}

	func scaled (newMin: Self, newMax: Self) -> Self {
		scaled(min: 0, max: 1, newMin: newMin, newMax: newMax)
	}

	func normalized (min: Self, max: Self) -> Self {
		scaled(min: min, max: max, newMin: 0, newMax: 1)
	}

	func clamped (min: Self, max: Self) -> Self {
		Swift.max(min, Swift.min(max, self))
	}

	func clampedNormalized (min: Self, max: Self) -> Self {
		self.clamped(min: min, max: max).normalized(min: min, max: max)
	}
}

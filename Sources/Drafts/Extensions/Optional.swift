public extension Optional {
	func unwrap (_ message: String) -> Wrapped {
		guard let value = self else { fatalError(message) }
		return value
	}
}

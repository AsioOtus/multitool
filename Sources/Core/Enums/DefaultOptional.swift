public struct DefaultOptional <Value> {
	public let optional: Value?
	public let `default`: Value

	public var value: Value { optional ?? `default` }

	public init (optional: Value?, default: Value) {
		self.optional = optional
		self.default = `default`
	}
}

public extension Optional {
	func `default` (_ value: Wrapped) -> DefaultOptional<Wrapped> {
		.init(optional: self, default: value)
	}
}

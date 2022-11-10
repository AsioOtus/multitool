public struct Source {
	public let components: [String]
	public let separator: String
	public var string: String { components.joined(separator: separator) }

	public init (_ components: [String], separator: String = ".") {
		self.components = components
		self.separator = separator
	}

	public init (_ component: String, separator: String = ".") {
		self.init([component], separator: separator)
	}

	public init (_ component: String, splitBy separator: Character) {
		let prepared = component
			.split(separator: separator)
			.map(String.init)

		self.init(prepared, separator: String(separator))
	}
}

public extension Source {
	func add (_ another: Self, separator: String? = nil) -> Self {
		.init(components + another.components, separator: separator ?? self.separator)
	}

	func add (_ component: String, separator: String? = nil) -> Self {
		add(.init(component), separator: separator)
	}
}

extension Source: ExpressibleByStringLiteral {
	public init (stringLiteral component: String) {
		self.init(component)
	}
}

extension Source: ExpressibleByArrayLiteral {
	public init (arrayLiteral components: Self...) {
		self.init(components.map(\.string))
	}
}

extension Source: RawRepresentable {
	public var rawValue: String { string }

	public init? (rawValue: String) {
		self.init(rawValue)
	}
}

extension Source: Codable { }

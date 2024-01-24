public struct Path {
	public let components: [String]
	public let separator: String

	public var divided: [Self] { components.map(Self.init) }

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

public extension Path {
	func add (_ another: Self, separator: String? = nil) -> Self {
		.init(components + another.components, separator: separator ?? self.separator)
	}

	func add (_ component: String, separator: String? = nil) -> Self {
		add(.init(component), separator: separator)
	}
}

extension Path: ExpressibleByStringLiteral {
	public init (stringLiteral component: String) {
		self.init(component)
	}
}

extension Path: ExpressibleByArrayLiteral {
	public init (arrayLiteral components: Self...) {
		self.init(components.map(\.description))
	}
}

extension Path: RawRepresentable {
	public var rawValue: String { description }

	public init? (rawValue: String) {
		self.init(rawValue)
	}
}

extension Path: CustomStringConvertible {
	public var description: String {
		components.joined(separator: separator)
	}
}

extension Path: Codable { }

extension Path: Equatable { }

public extension Sequence {
	var asArray: [Element] { Array(self) }
}

@available(macOS 10.15, *)
public extension Sequence {
	func asyncMap <T> (_ transform: (Element) async throws -> T) async rethrows -> [T] {
		var values = [T]()

		for element in self {
			try await values.append(transform(element))
		}

		return values
	}
}

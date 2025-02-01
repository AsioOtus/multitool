import Combine

public extension Publisher {
	var asyncValue: Output? {
		get async throws {
			if let lastValue = try await values.reduce(nil, { _, newValue in newValue }) {
				return lastValue
			} else {
				throw MissingValueError()
			}
		}
	}
}

public extension AsyncSequence {
  func last () async throws -> Element? {
	try await reduce(nil) { _, newValue in newValue }
  }
}

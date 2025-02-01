@preconcurrency import Combine

public extension Publisher where Self: Sendable, Output: Sendable {
	var asyncStream: AsyncThrowingStream<Output, some Error> {
		.init { continuation in
			let task = Task {
				do {
					for try await value in self.values {
						continuation.yield(value)
					}

					continuation.finish()
				} catch {
					continuation.finish(throwing: error)
				}
			}

			continuation.onTermination = { _ in
				task.cancel()
			}
		}
	}
}

public extension Publisher where Failure == Never, Self: Sendable, Output: Sendable {
	var asyncStream: AsyncStream<Output> {
		.init { continuation in
			let task = Task {
				for try await value in self.values {
					continuation.yield(value)
				}

				continuation.finish()
			}

			continuation.onTermination = { _ in
				task.cancel()
			}
		}
	}
}

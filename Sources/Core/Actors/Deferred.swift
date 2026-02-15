public actor Deferred <Value: Sendable> {
	private let channel: BroadcastChannel<Result<Value, Error>>

	public init () {
		self.channel = .init()
	}

	public func wait () async throws -> Value {
		for await value in await channel.subscribe() {
			switch value {
			case .success(let success):
				return success
			case .failure(let failure):
				throw failure
			}
		}

		fatalError()
	}

	@discardableResult
	public func waitResult () async -> Result<Value, Error> {
		for await result in await channel.subscribe() {
			return result
		}

		fatalError()
	}

	public nonisolated func succeed (_ value: Value) {
		Task {
			await channel.send(.success(value))
			await channel.finish()
		}
	}

	public nonisolated func fail (_ error: Error) {
		Task {
			await channel.send(.failure(error))
			await channel.finish()
		}
	}

	public nonisolated func cancel () {
		fail(DeferredCancellationError())
	}
}

extension Deferred where Value == Void {
	public init (of _: Value = ()) {
		self.init()
	}

	public nonisolated func succeed () {
		self.succeed(())
	}
}

public struct DeferredCancellationError: Error { }

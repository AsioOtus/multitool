import Foundation

public actor BroadcastChannel <Element: Sendable>: Sendable {
	private struct Subscriber {
		let id: UUID
		let continuation: AsyncStream<Element>.Continuation
	}

	private var subscribers: [UUID: AsyncStream<Element>.Continuation] = [:]
	private var isFinished = false
	
	public private(set) var bufferElement: Element?

	public init () { }

	public func subscribe (
		bufferingPolicy: AsyncStream<Element>.Continuation.BufferingPolicy = .unbounded
	) -> AsyncStream<Element> {
		.init(Element.self, bufferingPolicy: bufferingPolicy) { continuation in
			guard !isFinished else {
				continuation.finish()
				return
			}

			let id = UUID()
			subscribers[id] = continuation

			if let bufferElement {
				continuation.yield(bufferElement)
			}

			continuation.onTermination = { [weak self] _ in
				Task { await self?.removeSubscriber(id) }
			}
		}
	}

	public func send (_ element: Element) {
		guard !isFinished else { return }

		self.bufferElement = element

		for (_, continuation) in subscribers {
			continuation.yield(element)
		}
	}

	@discardableResult
	public nonisolated func fire (_ element: Element) -> Task<Void, Never> {
		Task {
			await send(element)
		}
	}

	public func finish () {
		guard !isFinished else { return }
		isFinished = true

		let current = subscribers
		subscribers.removeAll()

		for (_, continuation) in current {
			continuation.finish()
		}
	}

	private func removeSubscriber (_ id: UUID) {
		subscribers[id] = nil
	}
}

extension AsyncStream.Continuation.BufferingPolicy: @retroactive @unchecked Sendable { }

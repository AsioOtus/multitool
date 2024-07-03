import Foundation

public extension NSLock {
	func access <Value> (_ action: () -> Value) -> Value {
		lock()
		defer { unlock() }

		return action()
	}
}

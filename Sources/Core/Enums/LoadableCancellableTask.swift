public protocol LoadableCancellableTask {
	func cancel ()
}

extension Task: LoadableCancellableTask { }

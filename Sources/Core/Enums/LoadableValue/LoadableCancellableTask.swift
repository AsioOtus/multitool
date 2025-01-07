import Combine

public protocol CancellableLoadableTask {
	func cancel ()
}

extension Task: CancellableLoadableTask { }
extension AnyCancellable: CancellableLoadableTask { }

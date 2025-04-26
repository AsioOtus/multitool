import Combine

public extension Cancellable {
    func store <Value> (in loadable: inout LoadableValue<Value, Error, Self>) {
        loadable.setLoading(task: self)
    }
}

public extension LoadableValue where Failed == Error, LoadingTask: Cancellable, LoadingTask: CancellableLoadableTask {
    mutating func setCompletion (_ completion: Subscribers.Completion<Error>, noSuccessError: Error) {
        switch completion {
        case .finished where !isSuccessful: setFailed(noSuccessError)
        case .failure(let error): setFailed(error)
        default: break
        }
    }
}

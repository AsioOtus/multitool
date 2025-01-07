import Combine

public extension Cancellable {
    func store (in loadable: inout LoadableValue<String, Error, Self>) {
        loadable.setLoading(task: self)
    }
}

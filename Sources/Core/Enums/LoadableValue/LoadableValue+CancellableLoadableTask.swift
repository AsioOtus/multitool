public extension LoadableValue where LoadingTask: CancellableLoadableTask {
    func canceled () -> Self {
        loadingTask?.cancel()
        return self
    }

    func cancel () {
        loadingTask?.cancel()
    }

    mutating func set (_ another: Self) {
        self.cancel()
        self = another
    }

    mutating func setInitial () {
        self.cancel()
        self = .initial
    }

    mutating func setLoading (task: LoadingTask?) {
        self.cancel()
        self = self.loading(task: task)
    }

    mutating func setLoading (action: () throws -> LoadingTask) rethrows {
        self.setLoading(task: try action())
    }

    mutating func setLoading (task: LoadingTask?, value: Value?) {
        self.cancel()
        self = .loading(task: task, value: value)
    }

    mutating func setLoading (value: Value?, action: () throws -> LoadingTask) rethrows {
        self.setLoading(task: try action(), value: value)
    }

    mutating func setLoading () {
        self.setLoading(task: nil)
    }

    mutating func setSuccessful (_ value: Value) {
        self.cancel()
        self = .successful(value)
    }

    mutating func setFailed (_ failed: Failed) {
        self.cancel()
        self = self.failed(error: failed)
    }

    mutating func setFailed (_ failed: Failed, value: Value?) {
        self.cancel()
        self = .failed(error: failed, value: value)
    }
}

public extension LoadableValue where LoadingTask: CancellableLoadableTask, Failed == Error {
    mutating func setResult (
        action: () throws -> Value
    ) {
        do {
            self.setSuccessful(try action())
        } catch {
            self.setFailed(error)
        }
    }

    mutating func setResult (
        action: @Sendable () async throws -> Value
    ) async {
        do {
            self.setSuccessful(try await action())
        } catch {
            self.setFailed(error)
        }
    }
}

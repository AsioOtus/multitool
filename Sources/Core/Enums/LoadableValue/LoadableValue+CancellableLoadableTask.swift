public extension LoadableValue where LoadingTask: CancellableLoadableTask {
    func loading () -> Self {
        .loading(task: loadingTask, value: value)
    }

    static func loading () -> Self {
        .loading(task: nil, value: nil)
    }
}

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

    mutating func setLoading () {
        self.setLoading(task: nil)
    }

    mutating func setLoading (task: LoadingTask?, value: Value?) {
        self.cancel()
        self = .loading(task: task, value: value)
    }

    mutating func setLoading (
        action: () throws -> LoadingTask
    ) rethrows {
        self.setLoading(task: try action())
    }

    mutating func setLoading (
        value: Value?,
        action: () throws -> LoadingTask
    ) rethrows {
        self.setLoading(task: try action(), value: value)
    }

    mutating func setSuccessful (
        _ value: Value
    ) {
        self.cancel()
        self = .successful(value)
    }

    mutating func setFailed (
        _ failed: Failed
    ) {
        self.cancel()
        self = .failed(error: failed, value: value)
    }
}

public extension LoadableValue where LoadingTask: CancellableLoadableTask, Failed == Error {
    mutating func setResult (
        action: () throws -> Value
    ) {
        let task = self.loadingTask
        defer { task?.cancel() }

        do { self = try .successful(action()) }
        catch { self = .failed(error: error, value: value) }
    }

    mutating func setResult (
        action: () async throws -> Value
    ) async {
        let task = self.loadingTask
        defer { task?.cancel() }

        do { self = try await .successful(action()) }
        catch { self = .failed(error: error, value: value) }
    }
}

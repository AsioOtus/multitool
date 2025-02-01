public extension LoadableValue where LoadingTask == VoidTask {
    mutating func setLoading (
        priority: TaskPriority? = nil,
        action: @Sendable @escaping () async throws -> Void
    ) {
        self.setLoading(task: Task(priority: priority) { try await action() })
    }

    mutating func setLoading (
        value: Value?,
        priority: TaskPriority? = nil,
        action: @Sendable @escaping () async throws -> Void
    ) rethrows {
        self.setLoading(task: Task(priority: priority) { try await action() }, value: value)
    }

    func loading (
        priority: TaskPriority? = nil,
        action: @Sendable @escaping () async throws -> Void
    ) -> Self {
        loading(task: Task(priority: priority) { try await action() })
    }

    static func loading (
        value: Value? = nil,
        priority: TaskPriority? = nil,
        action: @Sendable @escaping () async throws -> Void
    ) -> Self {
        .loading(task: Task(priority: priority) { try await action() }, value: value)
    }
}

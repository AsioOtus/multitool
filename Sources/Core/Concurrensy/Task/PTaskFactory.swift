public protocol PTaskFactory: Sendable {
    @discardableResult
    func task <T: Sendable> (
        priority: TaskPriority?,
        @_inheritActorContext operation: @escaping @Sendable () async throws -> T
    ) -> Task<T, Error>

    @discardableResult
    func task <T: Sendable> (
        priority: TaskPriority?,
        @_inheritActorContext operation: @escaping @Sendable () async -> T
    ) -> Task<T, Never>

    @discardableResult
    func detached <T: Sendable> (
        priority: TaskPriority?,
        operation: @escaping @Sendable () async throws -> T
    ) -> Task<T, Error>

    @discardableResult
    func detached <T: Sendable> (
        priority: TaskPriority?,
        operation: @escaping @Sendable () async -> T
    ) -> Task<T, Never>
}

public extension PTaskFactory {
    @discardableResult
    func task <T: Sendable> (
        @_inheritActorContext operation: @escaping @Sendable () async throws -> T
    ) -> Task<T, Error> {
        task(priority: nil, operation: operation)
    }

    @discardableResult
    func task <T: Sendable> (
        @_inheritActorContext operation: @escaping @Sendable () async -> T
    ) -> Task<T, Never> {
        task(priority: nil, operation: operation)
    }

    @discardableResult
    func detached <T: Sendable> (
        operation: @escaping @Sendable () async throws -> T
    ) -> Task<T, Error> {
        detached(priority: nil, operation: operation)
    }

    @discardableResult
    func detached <T: Sendable> (
        operation: @escaping @Sendable () async -> T
    ) -> Task<T, Never> {
        detached(priority: nil, operation: operation)
    }
}

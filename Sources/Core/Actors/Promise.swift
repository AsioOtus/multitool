public typealias AsyncSignal <Value> = Promise<Value, Never>

public actor Promise<Value: Sendable, Failure: Error> {

    private enum State {
        case pending
        case completed(Result<Value, Failure>)
    }

    private var state: State = .pending
    private var continuations: [CheckedContinuation<Result<Value, Failure>, Never>] = []

    public init() {}

    public func resolve(_ value: Value) {
        fulfill(.success(value))
    }

    public func reject(_ error: Failure) {
        fulfill(.failure(error))
    }

    private func fulfill(_ result: Result<Value, Failure>) {
        guard case .pending = state else { return }
        state = .completed(result)
        for continuation in continuations {
            continuation.resume(returning: result)
        }
        continuations.removeAll()
    }

    public var value: Value {
        get async throws(Failure) {
            if case .completed(let result) = state {
                return try result.get()
            }
            let result: Result<Value, Failure> = await withCheckedContinuation { continuation in
                continuations.append(continuation)
            }
            return try result.get()
        }
    }
}

extension Promise where Value == Void {
    public func resolve() {
        resolve(())
    }
}

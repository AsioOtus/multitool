public extension LoadableValue where Failed == Error {
	func perform (
		action: () throws -> Value
	) -> Self {
		do {
			return try .successful(action())
		} catch {
			return self.failed(error: error)
		}
	}
	
	func perform (
		action: () async throws -> Value
	) async -> Self {
		do {
			return try await .successful(action())
		} catch {
			return self.failed(error: error)
		}
	}

    mutating func setPerform (
        action: () throws -> Value
    ) {
        do {
            try setSuccessful(action())
        } catch {
            setFailed(error)
        }
    }

    mutating func setPerform (
        action: () async throws -> Value
    ) async {
        do {
            try await setSuccessful(action())
        } catch {
            setFailed(error)
        }
    }

	init (catching: () throws -> Value) {
		do {
			self = try .successful(catching())
		} catch {
			self = .failed(error: error)
		}
	}

	init (asyncCatching: () async throws -> Value) async {
		do {
			self = try await .successful(asyncCatching())
		} catch {
			self = .failed(error: error)
		}
	}

	func catchingMapValue <NewValue> (
		_ mapping: (Value) throws -> NewValue
	) -> LoadableValue<NewValue, Failed, LoadingTask> where Failed == Error {
		do {
			return switch self {
			case .initial:                      .initial
			case .loading(let task, let value): .loading(task: task, value: try value.map(mapping))
			case .successful(let value):        .successful(try mapping(value))
			case .failed(let error, let value): .failed(error: error, value: try value.map(mapping))
			}
		} catch {
			return .failed(error: error)
		}
	}

	func catchingMapValue (
		_ mapping: (Value) throws -> Value
	) -> LoadableValue<Value, Failed, LoadingTask> where Failed == Error {
		do {
			return switch self {
			case .initial:                      .initial
			case .loading(let task, let value): .loading(task: task, value: try value.map(mapping))
			case .successful(let value):        .successful(try mapping(value))
			case .failed(let error, let value): .failed(error: error, value: try value.map(mapping))
			}
		} catch {
			return .failed(error: error, value: value)
		}
	}
}

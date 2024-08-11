public extension LoadableValue where Failed == Error {
	func result (
		action: () throws -> Value
	) -> Self {
		do {
			return try .successful(action())
		} catch {
			return self.failed(error: error)
		}
	}
	
	func result (
		action: () async throws -> Value
	) async -> Self {
		do {
			return try await .successful(action())
		} catch {
			return self.failed(error: error)
		}
	}

	static func result (catching: () throws -> Value) -> Self {
		do {
			return try .successful(catching())
		} catch {
			return .failed(error: error)
		}
	}

	static func result (asyncCatching: () async throws -> Value) async -> Self {
		do {
			return try await .successful(asyncCatching())
		} catch {
			return .failed(error: error)
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
			case .initial:                              .initial
			case .loading(let task, let previousValue): .loading(task: task, previousValue: try previousValue.map(mapping))
			case .successful(let value):                .successful(try mapping(value))
			case .failed(let error, let previousValue): .failed(error: error, previousValue: try previousValue.map(mapping))
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
			case .initial:                              .initial
			case .loading(let task, let previousValue): .loading(task: task, previousValue: try previousValue.map(mapping))
			case .successful(let value):                .successful(try mapping(value))
			case .failed(let error, let previousValue): .failed(error: error, previousValue: try previousValue.map(mapping))
			}
		} catch {
			return .failed(error: error, previousValue: value)
		}
	}
}

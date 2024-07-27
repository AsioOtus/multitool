public typealias Loadable<Value> = LoadableValue<Value, Error, VoidTask>

public enum LoadableValue <Value, Failed: Error, LoadingTask> {
	case initial
	case loading(Loading<Value, LoadingTask>)
	case successful(Value)
	case failed(Failed)
}

public extension LoadableValue {
	var debugName: String {
		switch self {
		case .initial:    "inital"
		case .loading:    "loading"
		case .successful: "successful"
		case .failed:     "failed"
		}
	}

	var isInitial: Bool    { if case .initial    = self { true } else { false } }
	var isLoading: Bool    { if case .loading    = self { true } else { false } }
	var isSuccessful: Bool { if case .successful = self { true } else { false } }
	var isFailed: Bool     { if case .failed     = self { true } else { false } }

	var value: Value? {
		switch self {
		case .initial: nil
		case .loading(let loading): loading.previousValue
		case .successful(let successful): successful
		case .failed: nil
		}
	}

	var loadingValue: Loading<Value, LoadingTask>? { if case .loading(let loading) = self { loading } else { nil } }
	var successfulValue: Value? { if case .successful(let value) = self { value } else { nil } }
}

public extension LoadableValue where Failed == Error {
	static func result (catching: () throws -> Value) -> Self {
		do {
			return try .successful(catching())
		} catch {
			return .failed(error)
		}
	}

	static func result (asyncCatching: () async throws -> Value) async -> Self {
		do {
			return try await .successful(asyncCatching())
		} catch {
			return .failed(error)
		}
	}

	static func result (to loadable: inout Self, catching: () throws -> Value) {
		loadable.setLoading()

		do {
			loadable = try .successful(catching())
		} catch {
			loadable = .failed(error)
		}
	}

	static func result (to loadable: inout Self, asyncCatching: () async throws -> Value) async {
		loadable.setLoading()

		do {
			loadable = try await .successful(asyncCatching())
		} catch {
			loadable = .failed(error)
		}
	}
}

public extension LoadableValue where Failed == Error {
	init (catching: () throws -> Value) {
		do {
			self = try .successful(catching())
		} catch {
			self = .failed(error)
		}
	}

	init (asyncCatching: () async throws -> Value) async {
		do {
			self = try await .successful(asyncCatching())
		} catch {
			self = .failed(error)
		}
	}
}

public extension LoadableValue {
	func loading (task: LoadingTask?) -> Self {
		switch self {
		case .initial: .loading(.init(task: task))
		case .loading(let loading): .loading(.init(previousValue: loading.previousValue, task: task))
		case .successful(let value): .loading(.init(previousValue: value, task: task))
		case .failed: .loading(.init(task: task))
		}
	}

	func loading (
		action: () throws -> LoadingTask
	) rethrows -> Self {
		loading(task: try action())
	}

	static func loading (
		previousValue: Value? = nil,
		task: LoadingTask
	) -> Self {
		.loading(.init(previousValue: previousValue, task: task))
	}

	static func loading (
		previousValue: Value? = nil,
		action: () throws -> LoadingTask
	) rethrows -> Self {
		.loading(.init(previousValue: previousValue, task: try action()))
	}
}

public extension LoadableValue where LoadingTask == VoidTask {
	func loading () -> Self {
		switch self {
		case .initial: .loading()
		case .loading: self
		case .successful(let value): .loading(.init(previousValue: value))
		case .failed: .loading()
		}
	}

	static func loading () -> Self {
		.loading(.init())
	}
}

public extension LoadableValue where LoadingTask: LoadableCancellableTask {
	@discardableResult
	func cancel () -> Self {
		loadingValue?.task?.cancel()
		return self
	}

	mutating func set (_ another: Self) {
		self.cancel()
		self = another
	}

	mutating func setInitialValue () {
		self.cancel()
		self = .initial
	}

	mutating func setSuccessfulValue (
		_ value: Value
	) {
		self.cancel()
		self = .successful(value)
	}

	mutating func setFailedValue (
		_ failed: Failed
	) {
		self.cancel()
		self = .failed(failed)
	}

	mutating func setLoading (task: LoadingTask?) {
		self.cancel()
		self = self.loading(task: task)
	}

	mutating func setLoading () {
		self.setLoading(task: nil)
	}

	mutating func setLoading (
		action: () throws -> LoadingTask
	) rethrows {
		self.setLoading(task: try action())
	}
}

public extension LoadableValue {
	mutating func set (_ another: Self) {
		self = another
	}

	mutating func setInitialValue () {
		self = .initial
	}

	mutating func setSuccessfulValue (
		_ value: Value
	) {
		self = .successful(value)
	}

	mutating func setFailedValue (
		_ failed: Failed
	) {
		self = .failed(failed)
	}

	mutating func setLoading (task: LoadingTask?) {
		self = self.loading(task: task)
	}

	mutating func setLoading () {
		self.setLoading(task: nil)
	}

	mutating func setLoading (
		action: () throws -> LoadingTask
	) rethrows {
		self.setLoading(task: try action())
	}
}

public extension LoadableValue {
	func mapValue <NewValue> (_ mapping: (Value) -> NewValue) -> LoadableValue<NewValue, Failed, LoadingTask> {
		switch self {
		case .initial:               .initial
		case .loading(let loading):  .loading(loading.mapValue(mapping: mapping))
		case .successful(let value): .successful(mapping(value))
		case .failed(let error):     .failed(error)
		}
	}

	func tryMapValue <NewValue> (_ mapping: (Value) throws -> NewValue) rethrows -> LoadableValue<NewValue, Failed, LoadingTask> {
		switch self {
		case .initial:               .initial
		case .loading(let loading):  .loading(try loading.mapValue(mapping: mapping))
		case .successful(let value): .successful(try mapping(value))
		case .failed(let error):     .failed(error)
		}
	}

	func replaceValue <NewValue> (with newSuccessful: NewValue) -> LoadableValue<NewValue, Failed, LoadingTask> {
		mapValue { _ in newSuccessful }
	}
}

public extension LoadableValue {
	var optionalSuccessful: LoadableValue<Value?, Failed, LoadingTask> {
		mapValue { $0 }
	}

	func replaceIfFailed (with successful: Value) -> Self {
		if case .failed = self {
			return .successful(successful)
		} else {
			return self
		}
	}

	func replaceWithNone () -> LoadableValue<None, Failed, LoadingTask> {
		replaceValue(with: .init())
	}
}

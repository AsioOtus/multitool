public typealias Loadable<Value> = LoadableValue<Value, Error, VoidTask>

public enum LoadableValue <Value, Failed: Error, LoadingTask> {
	case initial
	case loading(task: LoadingTask?, previousValue: Value?)
	case successful(Value)
	case failed(error: Failed, previousValue: Value?)
}

extension LoadableValue: Hashable where Value: Hashable, LoadingTask: Hashable, Failed: Hashable { }

public extension LoadableValue {
	var debugName: String {
		switch self {
		case .initial:    "initial"
		case .loading:    "loading"
		case .successful: "successful"
		case .failed:     "failed"
		}
	}

	var isInitial:    Bool { if case .initial    = self { true } else { false } }
	var isLoading:    Bool { if case .loading    = self { true } else { false } }
	var isSuccessful: Bool { if case .successful = self { true } else { false } }
	var isFailed:     Bool { if case .failed     = self { true } else { false } }

	var value: Value? {
		switch self {
		case .initial: nil
		case .loading(_, let previousValue): previousValue
		case .successful(let successful): successful
		case .failed(_, let previousValue): previousValue
		}
	}

	var loadingValue:    Value? { if case .loading(_, let previousValue) = self { previousValue } else { nil } }
	var successfulValue: Value? { if case .successful(let value) = self { value } else { nil } }
	var failedValue:     Value? { if case .failed(_, let previousValue) = self { previousValue } else { nil } }

	var loadingTask: LoadingTask? { if case .loading(let task, _) = self { task } else { nil } }
	var error: Failed? { if case .failed(let error, _) = self { error } else { nil } }
}

public extension LoadableValue {
	func loading (previousValue: Value?) -> Self {
		.loading(task: loadingTask, previousValue: previousValue)
	}

	func loading (task: LoadingTask?) -> Self {
		.loading(task: task, previousValue: value)
	}

	func loading (action: () throws -> LoadingTask) rethrows -> Self {
		loading(task: try action())
	}

	static func loading (previousValue: Value?) -> Self {
		.loading(task: nil, previousValue: previousValue)
	}

	static func loading (task: LoadingTask?) -> Self {
		.loading(task: task, previousValue: nil)
	}

	static func loading (
		previousValue: Value? = nil,
		action: () throws -> LoadingTask
	) rethrows -> Self {
		.loading(task: try action(), previousValue: previousValue)
	}

	func failed (error: Failed) -> Self {
		.failed(error: error, previousValue: value)
	}

	static func failed (error: Failed) -> Self {
		.failed(error: error, previousValue: nil)
	}
}

public extension LoadableValue {
	mutating func set (_ another: Self) {
		self = another
	}

	mutating func setInitial () {
		self = .initial
	}

	mutating func setSuccessful (
		_ value: Value
	) {
		self = .successful(value)
	}

	mutating func setFailed (
		_ failed: Failed
	) {
		self = .failed(error: failed, previousValue: value)
	}

	mutating func setLoading (task: LoadingTask?) {
		self = self.loading(task: task)
	}

	mutating func setLoading (task: LoadingTask?, previousValue: Value?) {
		self = .loading(task: task, previousValue: previousValue)
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
	func mapValue <NewValue> (
		_ mapping: (Value) -> NewValue
	) -> LoadableValue<NewValue, Failed, LoadingTask> {
		switch self {
		case .initial:                               .initial
		case .loading(let task, let previousValue):  .loading(task: task, previousValue: previousValue.map(mapping))
		case .successful(let value):                 .successful(mapping(value))
		case .failed(let error, let previousValue):  .failed(error: error, previousValue: previousValue.map(mapping))
		}
	}

	func mapSuccessfulValue (
		_ mapping: (Value) -> Value
	) -> LoadableValue<Value, Failed, LoadingTask> {
		switch self {
		case .initial:                               .initial
		case .loading(let task, let previousValue):  .loading(task: task, previousValue: previousValue)
		case .successful(let value):                 .successful(mapping(value))
		case .failed(let error, let previousValue):  .failed(error: error, previousValue: previousValue)
		}
	}

	func tryMapValue <NewValue> (
		_ mapping: (Value) throws -> NewValue
	) rethrows -> LoadableValue<NewValue, Failed, LoadingTask> {
		switch self {
		case .initial:                               .initial
		case .loading(let task, let previousValue):  .loading(task: task, previousValue: try previousValue.map(mapping))
		case .successful(let value):                 .successful(try mapping(value))
		case .failed(let error, let previousValue):  .failed(error: error, previousValue: try previousValue.map(mapping))
		}
	}

	func replaceValue <NewValue> (with newValue: NewValue) -> LoadableValue<NewValue, Failed, LoadingTask> {
		mapValue { _ in newValue }
	}

	func replaceSuccessfulValue (with newValue: Value) -> LoadableValue<Value, Failed, LoadingTask> {
		mapSuccessfulValue { _ in newValue }
	}

	func nilledValue <T> () -> LoadableValue<T?, Failed, LoadingTask> where Value == Optional<T> {
		switch self {
		case .initial: self
		case .loading(let task, _): .loading(task: task, previousValue: nil)
		case .successful:           .successful(nil)
		case .failed(let error, _): .failed(error: error, previousValue: nil)
		}
	}

	func nilledLoadingValue () -> Self {
		if case .loading(let task, _) = self { .loading(task: task, previousValue: nil) }
		else { self }
	}

	func nilledFailedValue () -> Self {
		if case .failed(let error, _) = self { .failed(error: error, previousValue: nil) }
		else { self }
	}
}

public extension LoadableValue {
	var optionalValue: LoadableValue<Value?, Failed, LoadingTask> {
		mapValue { $0 }
	}

	func replaceWithNone () -> LoadableValue<None, Failed, LoadingTask> {
		replaceValue(with: .init())
	}

	func replaceIfFailed (with successful: Value) -> Self {
		if case .failed = self {
			return .successful(successful)
		} else {
			return self
		}
	}
}

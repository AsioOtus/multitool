public extension Result {
	func loadable () -> LoadableValue<Success, Failure, VoidTask> {
		switch self {
		case .success(let success): .successful(success)
		case .failure(let failure): .failed(failure)
		}
	}
}

public extension Result {
	func loadable <Value> (_ mapping: (Success) -> LoadableValue<Value, Error, VoidTask>) -> LoadableValue<Value, Error, VoidTask> {
		switch self {
		case .success(let success): mapping(success)
		case .failure(let error): .failed(error)
		}
	}

	func loadable <Value> (_ mapping: (Success) -> Value) -> LoadableValue<Value, Error, VoidTask> {
		switch self {
		case .success(let success): .successful(mapping(success))
		case .failure(let error): .failed(error)
		}
	}

	func loadable () -> LoadableValue<Success, Error, VoidTask> {
		switch self {
		case .success(let success): .successful(success)
		case .failure(let error): .failed(error)
		}
	}
}

public extension LoadableValue {
	var result: Result<Value, Failed>? {
		switch self {
		case .initial: nil
		case .loading: nil
		case .successful(let successful): .success(successful)
		case .failed(let failed): .failure(failed)
		}
	}
}

public extension LoadableValue {
	mutating func replace (with result: Result<Value, Failed>) {
		switch result {
		case .success(let value): self.setSuccessfulValue(value)
		case .failure(let error): self.setFailedValue(error)
		}
	}
}

public extension LoadableValue where LoadingTask: LoadableCancellableTask {
	mutating func replace (with result: Result<Value, Failed>) {
		switch result {
		case .success(let value): self.setSuccessfulValue(value)
		case .failure(let error): self.setFailedValue(error)
		}
	}
}

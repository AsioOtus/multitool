public extension Result {
	func loadable () -> LoadableValue<Success, Failure, VoidTask> {
		switch self {
		case .success(let success): .successful(success)
		case .failure(let failure): .failed(error: failure)
		}
	}
}

public extension Result {
    func loadable <Value> (
        _ mapping: (Success) -> LoadableValue<Value, Error, VoidTask>
    ) -> LoadableValue<Value, Error, VoidTask> {
		switch self {
		case .success(let success): mapping(success)
		case .failure(let failure): .failed(error: failure)
		}
	}

    func loadable <Value> (
        _ mapping: (Success) -> Value
    ) -> LoadableValue<Value, Error, VoidTask> {
		switch self {
		case .success(let success): .successful(mapping(success))
		case .failure(let failure): .failed(error: failure)
		}
	}

	func loadable () -> LoadableValue<Success, Error, VoidTask> {
		switch self {
		case .success(let success): .successful(success)
		case .failure(let failure): .failed(error: failure)
		}
	}
}

public extension LoadableValue {
	var result: Result<Value, Failed>? {
		switch self {
		case .initial: nil
		case .loading: nil
		case .successful(let successful): .success(successful)
		case .failed(let error, _): .failure(error)
		}
	}
}

public extension LoadableValue {
	mutating func replace (with result: Result<Value, Failed>) {
		switch result {
		case .success(let value): self.setSuccessful(value)
		case .failure(let error): self.setFailed(error)
		}
	}
}

public extension LoadableValue where LoadingTask: CancellableLoadableTask {
	mutating func replace (with result: Result<Value, Failed>) {
		switch result {
		case .success(let value): self.setSuccessful(value)
		case .failure(let error): self.setFailed(error)
		}
	}
}

public typealias Loadable<Value> = Processable<Void, Loading<Value>, Value, Error>

public extension Loadable {
	typealias Value = Successful
}

extension Loadable: Equatable
where
Initial == Void,
Processing == Loading<Successful>,
Successful: Equatable,
Failed: Error
{
	public static func == (lhs: Self, rhs: Self) -> Bool {
		switch (lhs, rhs) {
		case (.initial, .initial): true
		case (.processing(let lSubscriptions), .processing(let rSubscriptions)): lSubscriptions == rSubscriptions
		case (.successful(let lValue), .successful(let rValue)): lValue == rValue
		case (.failed(let lError), .failed(let rError)): type(of: lError) == type(of: rError)
		default: false
		}
	}
}

public extension Loadable where Processing == Loading<Value> {
	var loadingValue: Processing? { processingValue }

	var isLoading: Bool { isProcessing }

	var value: Value? {
		switch self {
		case .initial: nil
		case .processing(let loading): loading.previousValue
		case .successful(let successful): successful
		case .failed: nil
		}
	}

	func mapLoading <NewProcessing> (_ mapping: (Processing) -> NewProcessing) -> Processable<Initial, NewProcessing, Value, Failed> {
		mapProcessingValue(mapping)
	}

	static func loading (_ loading: Loading<Value>) -> Self {
		.processing(loading)
	}

	static func loading () -> Self { .processing(.init()) }
}

public extension Loadable
where
Initial == Void,
Processing == Loading<Value>
{
	func mapValue <NewValue> (_ mapping: (Value) -> NewValue) -> Loadable<NewValue> {
		switch self {
		case .initial(let v):    .initial(v)
		case .processing(let v): .processing(v.mapValue(mapping: mapping))
		case .successful(let v): .successful(mapping(v))
		case .failed(let e):     .failed(e)
		}
	}

	func replaceValue <NewValue> (with newSuccessful: NewValue) -> Loadable<NewValue> {
		mapValue { _ in newSuccessful }
	}

	mutating func setValue (_ value: Value) {
		self = switch self {
		case .initial(let v):    .initial(v)
		case .processing(let v): .processing(v.replaceValue(with: value))
		case .successful:        .successful(value)
		case .failed(let e):     .failed(e)
		}
	}

	func tryMapValue <NewSuccessful> (_ mapping: (Value) throws -> NewSuccessful) -> Loadable<NewSuccessful> {
		do {
			return switch self {
			case .initial(let v):    .initial(v)
			case .processing(let v): .processing(try v.mapValue(mapping: mapping))
			case .successful(let v): .successful(try mapping(v))
			case .failed(let e):     .failed(e)
			}
		} catch {
			return .failed(error)
		}
	}

	func loading (task: Loading<Value>.LoadingTask? = nil) -> Self {
		self.loadingValue?.task?.cancel()

		return switch self {
		case .initial: .loading()
		case .processing: self
		case .successful(let value): .loading(.init(previousValue: value, task: task))
		case .failed: .loading()
		}
	}

	func loadingWithoutCancelation (task: Loading<Value>.LoadingTask? = nil) -> Self {
		switch self {
		case .initial: .loading()
		case .processing: self
		case .successful(let value): .loading(.init(previousValue: value, task: task))
		case .failed: .loading()
		}
	}

	mutating func setLoading (task: Loading<Value>.LoadingTask? = nil) {
		self.loadingValue?.task?.cancel()

		self = self.loading(task: task)
	}

	mutating func setLoadingWithoutCancelation (task: Loading<Value>.LoadingTask? = nil) {
		self = self.loading(task: task)
	}
}

public extension Loadable
where
Initial == Void,
Processing == Loading<Value>,
Failed: Error {
	func replaceWithNone () -> Loadable<None> {
		replaceValue(with: .init())
	}
}

public extension Loadable
where
Initial == Void,
Processing == Loading<Successful>,
Failed == Error
{
	static func result (catching: () throws -> Successful) -> Self {
		do {
			return try .successful(catching())
		} catch {
			return .failed(error)
		}
	}

	static func result (asyncCatching: () async throws -> Successful) async -> Self {
		do {
			return try await .successful(asyncCatching())
		} catch {
			return .failed(error)
		}
	}

	static func result (to loadable: inout Self, catching: () throws -> Successful) {
		loadable = .loading()

		do {
			loadable = try .successful(catching())
		} catch {
			loadable = .failed(error)
		}
	}

	static func result (to loadable: inout Self, asyncCatching: () async throws -> Successful) async {
		loadable = .loading()

		do {
			loadable = try await .successful(asyncCatching())
		} catch {
			loadable = .failed(error)
		}
	}
}

public extension Loadable
where
Initial == Void,
Processing == Loading<Value>,
Failed == Error
{
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

	func loading (
		action: () async throws -> Loading<Value>.LoadingTask
	) async rethrows -> Self {
		let task = try await action()
		return loading(task: task)
	}

	mutating func setLoading (
		action: () async throws -> Loading<Value>.LoadingTask
	) async rethrows {
		let task = try await action()
		self = loading(task: task)
	}

	static func loading (
		previousValue: Value? = nil,
		action: () async throws -> Loading<Value>.LoadingTask
	) async rethrows -> Self {
		let task = try await action()
		return .loading(.init(previousValue: previousValue, task: task))
	}
}

public extension Loadable {
	var optionalSuccessful: Processable<Initial, Processing, Value?, Failed> {
		mapSuccessfulValue { $0 }
	}

	func replaceFailed (with successful: Value) -> Self {
		if case .failed = self {
			return .successful(successful)
		} else {
			return self
		}
	}
}

public extension Result {
	func loadable <Value> (_ mapping: (Success) -> Loadable<Value>) -> Loadable<Value> {
		switch self {
		case .success(let success): mapping(success)
		case .failure(let error): .failed(error)
		}
	}

	func loadable <Value> (_ mapping: (Success) -> Value) -> Loadable<Value> {
		switch self {
		case .success(let success): .successful(mapping(success))
		case .failure(let error): .failed(error)
		}
	}

	func loadable () -> Loadable<Success> {
		switch self {
		case .success(let success): .successful(success)
		case .failure(let error): .failed(error)
		}
	}
}

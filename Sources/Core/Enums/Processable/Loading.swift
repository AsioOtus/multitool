public struct Loading <Value, LoadingTask> {
	public let previousValue: Value?
	public let task: LoadingTask?

	public init (
		previousValue: Value? = nil,
		task: LoadingTask?
	) {
		self.previousValue = previousValue
		self.task = task
	}

	public init (
		previousValue: Value? = nil,
		task: LoadingTask? = nil
	) where LoadingTask == VoidTask {
		self.previousValue = previousValue
		self.task = task
	}
}

extension Loading {
	func replaceValue (with value: Value) -> Self {
		.init(
			previousValue: value,
			task: task
		)
	}

	func mapValue <NewValue> (mapping: (Value) -> NewValue) -> Loading<NewValue, LoadingTask> {
		.init(
			previousValue: previousValue.map(mapping),
			task: task
		)
	}

	func mapValue <NewValue> (mapping: (Value) throws -> NewValue) rethrows -> Loading<NewValue, LoadingTask> {
		.init(
			previousValue: try previousValue.map(mapping),
			task: task
		)
	}
}

extension Loading: Equatable where Value: Equatable, LoadingTask: Equatable { }
extension Loading: Hashable where Value: Hashable, LoadingTask: Hashable { }

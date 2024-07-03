public struct Loading <Value> {
	public typealias LoadingTask = Task<Void, Never>

	public let previousValue: Value?
	public let task: LoadingTask?

	public init (
		previousValue: Value? = nil,
		task: LoadingTask? = nil
	) {
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

	func mapValue <NewValue> (mapping: (Value) -> NewValue) -> Loading<NewValue> {
		.init(
			previousValue: previousValue.map(mapping),
			task: task
		)
	}

	func mapValue <NewValue> (mapping: (Value) throws -> NewValue) rethrows -> Loading<NewValue> {
		.init(
			previousValue: try previousValue.map(mapping),
			task: task
		)
	}
}

extension Loading: Equatable where Value: Equatable { }

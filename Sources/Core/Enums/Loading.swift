public struct Loading <Value> {
	public typealias LoadingTask = Task<Value, Error>

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
	func mapValue <NewValue> (mapping: (Value) -> NewValue) -> Loading<NewValue> {
		.init(
			previousValue: previousValue.map(mapping)
		)
	}

	func mapValue <NewValue> (mapping: (Value) throws -> NewValue) rethrows -> Loading<NewValue> {
		.init(
			previousValue: try previousValue.map(mapping)
		)
	}
}

extension Loading: Equatable where Value: Equatable { }
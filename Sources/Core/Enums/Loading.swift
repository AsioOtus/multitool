public struct Loading <Value, LT> {
	public let previousValue: Value?
	public let task: LT?

	public init (
		previousValue: Value? = nil,
		task: LT?
	) {
		self.previousValue = previousValue
		self.task = task
	}

	public init (
		previousValue: Value? = nil,
		task: LT? = nil
	) where LT == VoidTask {
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

	func mapValue <NewValue> (mapping: (Value) -> NewValue) -> Loading<NewValue, LT> {
		.init(
			previousValue: previousValue.map(mapping),
			task: task
		)
	}

	func mapValue <NewValue> (mapping: (Value) throws -> NewValue) rethrows -> Loading<NewValue, LT> {
		.init(
			previousValue: try previousValue.map(mapping),
			task: task
		)
	}
}

extension Loading: Equatable where Value: Equatable, LT: Equatable { }

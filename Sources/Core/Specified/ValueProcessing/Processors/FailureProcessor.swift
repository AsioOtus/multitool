struct FailureProcessor <Value, Failure>: ProcessorProtocol {
	static var name: String { "failure" }
	
	let label: String?
	let failure: Failure?
	
	init (label: String? = nil, _ failure: Failure? = nil) {
		self.label = label
		self.failure = failure
	}
	
	func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		.single(.init(.failure(failure), FailureProcessor.name, label))
	}
}

extension AnyProcessor {
	static func failure (label: String? = nil, _ failure: Failure? = nil) -> Self {
		FailureProcessor(label: label, failure).eraseToAnyProcessor()
	}
}

struct SuccessProcessor <Value, Failure>: ProcessorProtocol {
	static var name: String { "success" }
	
	let label: String?
	
	init (label: String? = nil) {
		self.label = label
	}
	
	func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		.single(.init(.success(value), SuccessProcessor.name, label))
	}
}

extension AnyProcessor {
	static func success (label: String? = nil) -> Self {
		SuccessProcessor(label: label).eraseToAnyProcessor()
	}
}

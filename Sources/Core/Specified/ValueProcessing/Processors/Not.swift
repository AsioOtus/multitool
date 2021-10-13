struct Not <Value, Failure>: ProcessorProtocol {
	static var name: String { "not" }
	
	let processor: AnyProcessor<Value, Failure>
	let failure: Failure?
	
	init (_ processor: AnyProcessor<Value, Failure>, _ failure: Failure? = nil) {
		self.processor = processor
		self.failure = failure
	}
	
	func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		let processingResult = processor.process(value)
		if case .success = processingResult.summaryResult.category {
			return .single(.init(.failure(failure), Not.name, label))
		} else {
			return .single(.init(.success(value), Not.name, label))
		}
	}
}

extension AnyProcessor {
	static func not (_ processor: AnyProcessor<Value, Failure>, _ failure: Failure? = nil) -> Self {
		Not(processor, failure).eraseToAnyProcessor()
	}
}

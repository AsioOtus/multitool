extension Processing {
	enum ActionResult {
		case success(Value)
		case failure
		
		init (_ bool: Bool, _ value: Value) {
			self = bool ? .success(value) : .failure
		}
	}
}

extension ProcessingResult {
	init (_ processingResult: Processing<Value, Failure>.ActionResult, _ value: Value, _ failure: Failure? = nil, _ label: String? = nil) {
		switch processingResult {
		case let .success(value):
			self = .single(.init(.success(value), Processing<Value, Failure>.name, label))
			
		case .failure:
			self = .single(.init(.failure(failure), Processing<Value, Failure>.name, label))
		}
	}
}

struct Processing <Value, Failure>: ProcessorProtocol {
	static var name: String { "processing" }
	
	let label: String?
	
	let action: (Value) -> ActionResult
	let failure: Failure?
	
	init (label: String? = nil, _ failure: Failure? = nil, _ action: @escaping (Value) -> ActionResult) {
		self.label = label
		self.failure = failure
		self.action = action
	}
	
	func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		let actionResult = action(value)
		return .init(actionResult, value, failure, label)
	}
}

extension AnyProcessor {
	static func process (label: String? = nil, _ failure: Failure? = nil, _ action: @escaping (Value) -> Processing<Value, Failure>.ActionResult) -> Self {
		Processing(label: label, failure, action).eraseToAnyProcessor()
	}
	
	static func process (_ processing: Processing<Value, Failure>) -> Self {
		processing.eraseToAnyProcessor()
	}
}

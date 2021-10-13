extension Validation {
	enum ActionResult {
		case success
		case failure
		
		init (_ bool: Bool) {
			self = bool ? .success : .failure
		}
	}
}

extension ProcessingResult {
	init (_ validationResult: Validation<Value, Failure>.ActionResult, _ value: Value, _ failure: Failure? = nil, _ label: String? = nil) {
		switch validationResult {
		case .success:
			self = .single(.init(.success(value), Validation<Value, Failure>.name, label))
			
		case .failure:
			self = .single(.init(.failure(failure), Validation<Value, Failure>.name, label))
		}
	}
}

struct Validation <Value, Failure>: ProcessorProtocol {
	static var name: String { "validation" }
	
	let label: String?
	let failure: Failure?
	let action: (Value) -> (ActionResult)
	
	init (label: String? = nil, _ failure: Failure? = nil, _ action: @escaping (Value) -> (ActionResult)) {
		self.label = label
		self.failure = failure
		self.action = action
	}
	
	func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		let actionResult = action(value)
		return .init(actionResult, value, failure, label)
	}
}

extension AnyProcessor where Value == String {
	static func longerThan (_ length: Int, _ failure: Failure? = nil) -> Self {
		Validation(label: "Longer than \(length)", failure) { value in
			.init(value.count > length)
		}
		.eraseToAnyProcessor()
	}
	
	static func countEqualsTo (_ length: Int, _ failure: Failure? = nil) -> Self {
		Validation(label: "Count equals to \(length)", failure) { value in
			.init(value.count == length)
		}
		.eraseToAnyProcessor()
	}
	
	static func equalsTo (_ string: String, _ failure: Failure? = nil) -> Self {
		Validation(label: "Equals to \"\(string)\"", failure) { value in
			.init(value == string)
		}
		.eraseToAnyProcessor()
	}
	
	static func startsWith (_ string: String, _ failure: Failure? = nil) -> Self {
		Validation(label: "Starts with \"\(string)\"", failure) { value in
			.init(value.starts(with: string))
		}
		.eraseToAnyProcessor()
	}
	
	static func endsWith (_ string: String, _ failure: Failure? = nil) -> Self {
		Validation(label: "Ends with \"\(string)\"", failure) { value in
			.init(value.hasSuffix(string))
		}
		.eraseToAnyProcessor()
	}
}

extension AnyProcessor {
	static func validate (label: String? = nil, _ failure: Failure? = nil, _ action: @escaping (Value) -> Validation<Value, Failure>.ActionResult) -> Self {
		Validation(label: label, failure, action).eraseToAnyProcessor()
	}
	
	static func validate (_ validation: Validation<Value, Failure>) -> Self {
		validation.eraseToAnyProcessor()
	}
}

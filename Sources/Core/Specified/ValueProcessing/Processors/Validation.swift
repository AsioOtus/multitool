public extension Validation {
	enum ActionResult {
		case success
		case failure
		
		public init (_ bool: Bool) {
			self = bool ? .success : .failure
		}
	}
}

public extension ProcessingResult {
	init (_ validationResult: Validation<Value, Failure>.ActionResult, _ value: Value, _ failure: Failure? = nil, _ label: String? = nil) {
		switch validationResult {
		case .success:
			self = .single(.init(.success(value), Validation<Value, Failure>.name, label))
			
		case .failure:
			self = .single(.init(.failure(failure), Validation<Value, Failure>.name, label))
		}
	}
}

public struct Validation <Value, Failure>: ProcessorProtocol {
	public static var name: String { "validation" }
	
	public let label: String?
	public let failure: Failure?
	public let action: (Value) -> (ActionResult)
	
	public init (label: String? = nil, _ failure: Failure? = nil, _ action: @escaping (Value) -> (ActionResult)) {
		self.label = label
		self.failure = failure
		self.action = action
	}
	
	public func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		let actionResult = action(value)
		return .init(actionResult, value, failure, label)
	}
}

public extension AnyProcessor where Value == String {
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

public extension AnyProcessor {
	static func validate (label: String? = nil, _ failure: Failure? = nil, _ action: @escaping (Value) -> Validation<Value, Failure>.ActionResult) -> Self {
		Validation(label: label, failure, action).eraseToAnyProcessor()
	}
	
	static func validate (_ validation: Validation<Value, Failure>) -> Self {
		validation.eraseToAnyProcessor()
	}
}

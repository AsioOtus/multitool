extension Processing {
	public enum ActionResult {
		case success(Value)
		case failure
		
		public init (_ bool: Bool, _ value: Value) {
			self = bool ? .success(value) : .failure
		}
	}
}

public extension ProcessingResult {
	init (_ processingResult: Processing<Value, Failure>.ActionResult, _ value: Value, _ failure: Failure? = nil, _ label: String? = nil) {
		switch processingResult {
		case let .success(value):
			self = .single(.init(.success(value), Processing<Value, Failure>.name, label))
			
		case .failure:
			self = .single(.init(.failure(failure), Processing<Value, Failure>.name, label))
		}
	}
}

public struct Processing <Value, Failure>: ProcessorProtocol {
	public static var name: String { "processing" }
	
	public let label: String?
	
	public let action: (Value) -> ActionResult
	public let failure: Failure?
	
	public init (label: String? = nil, _ failure: Failure? = nil, _ action: @escaping (Value) -> ActionResult) {
		self.label = label
		self.failure = failure
		self.action = action
	}
	
	public init (label: String? = nil, _ failure: Failure? = nil, _ action: @escaping (Value) -> Value) {
		self.label = label
		self.failure = failure
		self.action =  { .success(action($0)) }
	}
	
	public func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		let actionResult = action(value)
		return .init(actionResult, value, failure, label)
	}
}

public extension AnyProcessor {
	static func process (label: String? = nil, _ failure: Failure? = nil, _ action: @escaping (Value) -> Processing<Value, Failure>.ActionResult) -> Self {
		Processing(label: label, failure, action).eraseToAnyProcessor()
	}
	
	static func process (label: String? = nil, _ failure: Failure? = nil, _ action: @escaping (Value) -> Value) -> Self {
		Processing(label: label, failure, action).eraseToAnyProcessor()
	}
	
	static func process (_ processing: Processing<Value, Failure>) -> Self {
		processing.eraseToAnyProcessor()
	}
}

extension FailableProcessing {
	public enum ActionResult {
		case success(Value)
		case failure
		
		public init (_ bool: Bool, _ value: Value) {
			self = bool ? .success(value) : .failure
		}
	}
}

public extension ProcessingResult {
	init (_ processingResult: FailableProcessing<Value, Failure>.ActionResult, _ value: Value, _ failure: Failure, _ label: String? = nil) {
		switch processingResult {
		case let .success(value):
			self = .single(.init(.success(value), FailableProcessing<Value, Failure>.name, label))
			
		case .failure:
			self = .single(.init(.failure(failure), FailableProcessing<Value, Failure>.name, label))
		}
	}
}

public struct FailableProcessing <Value, Failure>: ProcessorProtocol {
	public static var name: String { "failable processing" }
		
	public let processing: (Value) -> ActionResult
	public let failure: (Value) -> Failure
	
	public let label: String?

	public init (label: String? = nil, failure: @escaping (Value) -> Failure, processing: @escaping (Value) -> ActionResult) {
		self.label = label
		self.failure = failure
		self.processing = processing
	}
	
	public init (label: String? = nil, failure: Failure, processing: @escaping (Value) -> ActionResult) {
		self.init(label: label, failure: { _ in failure }, processing: processing)
	}
	
	
	public func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		let actionResult = processing(value)
		let failure = failure(value)
		return .init(actionResult, value, failure, label)
	}
}

public extension AnyProcessor {
	static func process (label: String? = nil, failure: Failure, processing: @escaping (Value) -> FailableProcessing<Value, Failure>.ActionResult) -> Self {
		FailableProcessing(label: label, failure: failure, processing: processing).eraseToAnyProcessor()
	}
	
	static func process (label: String? = nil, failure: @escaping (Value) -> Failure, processing: @escaping (Value) -> FailableProcessing<Value, Failure>.ActionResult) -> Self {
		FailableProcessing(label: label, failure: failure, processing: processing).eraseToAnyProcessor()
	}
	
	static func process (_ processing: FailableProcessing<Value, Failure>) -> Self {
		processing.eraseToAnyProcessor()
	}
}

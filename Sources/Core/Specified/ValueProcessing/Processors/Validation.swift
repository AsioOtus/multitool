public extension ProcessingResult {
	init (_ isSuccess: Bool, _ value: Value, _ failure: Failure, _ label: String? = nil) {
		self = isSuccess
			? .single(.init(.success(value), Validation<Value, Failure>.name, label))
			: .single(.init(.failure(failure), Validation<Value, Failure>.name, label))
	}
}

public struct Validation <Value, Failure>: ProcessorProtocol {
	public static var name: String { "validation" }
	
	public let label: String?
	public let failure: Failure
	public let predicate: (Value) -> Bool
	
	public init (label: String? = nil, failure: Failure, predicate: @escaping (Value) -> Bool) {
		self.label = label
		self.failure = failure
		self.predicate = predicate
	}
	
	public init (label: String? = nil, failure: Failure, predicate: @escaping () -> Bool) {
		self.init(label: label, failure: failure, predicate: { _ in predicate() })
	}
	
	public func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		let actionResult = predicate(value)
		return .init(actionResult, value, failure, label)
	}
}

public extension AnyProcessor where Value == String {
	static func longerThan (_ length: Int, failure: Failure) -> Self {
		Validation(label: "Longer than \(length)", failure: failure) { value in value.count > length }
		.eraseToAnyProcessor()
	}
	
	static func countEqualsTo (_ length: Int, failure: Failure) -> Self {
		Validation(label: "Count equals to \(length)", failure: failure) { value in value.count == length }
		.eraseToAnyProcessor()
	}
	
	static func equalsTo (_ string: String, failure: Failure) -> Self {
		Validation(label: "Equals to \"\(string)\"", failure: failure) { value in value == string }
		.eraseToAnyProcessor()
	}
	
	static func startsWith (_ string: String, failure: Failure) -> Self {
		Validation(label: "Starts with \"\(string)\"", failure: failure) { value in value.starts(with: string) }
		.eraseToAnyProcessor()
	}
	
	static func endsWith (_ string: String, failure: Failure) -> Self {
		Validation(label: "Ends with \"\(string)\"", failure: failure) { value in value.hasSuffix(string) }
		.eraseToAnyProcessor()
	}
}

public extension AnyProcessor {
	static func validate (label: String? = nil, failure: Failure, predicate: @escaping (Value) -> Bool) -> Self {
		Validation(label: label, failure: failure, predicate: predicate).eraseToAnyProcessor()
	}
	
	static func validate (label: String? = nil, failure: Failure, predicate: @escaping () -> Bool) -> Self {
		Validation(label: label, failure: failure, predicate: predicate).eraseToAnyProcessor()
	}
	
	static func validate (_ validation: Validation<Value, Failure>) -> Self {
		validation.eraseToAnyProcessor()
	}
}

public protocol ProcessorProtocol {
	associatedtype Value
	associatedtype Failure
	
	var label: String? { get }
	
	func process (_ value: Value) -> ProcessingResult<Value, Failure>
}

public extension ProcessorProtocol {
	var label: String? { nil }
}

public protocol ProcessorProtocol {
	associatedtype Value
	associatedtype Failure
	
	static var name: String { get }
	
	var label: String? { get }
	
	func process (_ value: Value) -> ProcessingResult<Value, Failure>
}

public extension ProcessorProtocol {
	var label: String? { nil }
}

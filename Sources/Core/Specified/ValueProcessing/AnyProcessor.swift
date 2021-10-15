public struct AnyProcessor<Value, Failure>: ProcessorProtocol {
	public static var name: String { "any processor" }
	
	public let processing: (Value) -> ProcessingResult<Value, Failure>
	
	public init <Processor: ProcessorProtocol> (_ processor: Processor) where Processor.Value == Value, Processor.Failure == Failure {
		processing = processor.process
	}
	
	public func process (_ value: Value) -> ProcessingResult<Value, Failure> {
		processing(value)
	}
}

public extension ProcessorProtocol {
	func eraseToAnyProcessor () -> AnyProcessor<Value, Failure> {
		.init(self)
	}
}

@resultBuilder
public struct ArrayBuilder {
	public static func buildBlock <T> (_ components: T...) -> [T] {
		components
	}
}

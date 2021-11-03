public struct Untracked <Value, Failure>: ProcessorProtocol {
	public static var name: String { "untracked" }
	
	public let processors: [AnyProcessor<Value, Failure>]
	
	public init (_ processors: [AnyProcessor<Value, Failure>]) {
		self.processors = processors
	}
	
	public func process (_ originalValue: Value) -> ProcessingResult<Value, Failure> {
		var results = [ProcessingResult<Value, Failure>]()
		
		var value = originalValue
		for processor in processors {
			let result = processor.process(value)
			results.append(result)
		}
		
		return .multiple(.init(results: results, summary: .init(.success(value), Self.name)))
	}
}

public extension AnyProcessor {
	static func untracked (_ processors: [Self]) -> Self {
		Untracked(processors).eraseToAnyProcessor()
	}
	
	static func untracked (@ProcessorBuilder _ processors: () -> ([Self])) -> Self {
		Untracked(processors()).eraseToAnyProcessor()
	}
}

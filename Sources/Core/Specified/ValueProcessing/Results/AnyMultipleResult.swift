public struct AnyMultipleResult <Value, Failure>: MultipleResultProtocol {	
	public let results: [ProcessingResult<Value, Failure>]
	public let summaryResult: SingleResult<Value, Failure>
	
	public init <MultipleResult: MultipleResultProtocol> (_ multipleResult: MultipleResult) where MultipleResult.Value == Value, MultipleResult.Failure == Failure {
		self.results = multipleResult.results
		self.summaryResult = multipleResult.summaryResult
	}
}

public extension MultipleResultProtocol {
	func eraseToAnyMultipleResult () -> AnyMultipleResult<Value, Failure> {
		.init(self)
	}
}

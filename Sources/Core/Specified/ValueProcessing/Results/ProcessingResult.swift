public enum ProcessingResult <Value, Failure> {
	case single(SingleResult<Value, Failure>)
	indirect case multiple(AnyMultipleResult<Value, Failure>)
	
	public var summaryResult: SingleResult<Value, Failure> {
		switch self {
		case .single(let singleResult):
			return singleResult
			
		case .multiple(let multipleResult):
			return multipleResult.summaryResult
		}
	}
	
	public var description: String {
		switch self {
		case .single(let singleResult):
			return singleResult.description
			
		case .multiple(let multipleResult):
			return multipleResult.description
		}
	}
}

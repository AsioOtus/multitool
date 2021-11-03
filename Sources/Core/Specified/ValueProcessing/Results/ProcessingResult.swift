public enum ProcessingResult <Value, Failure> {
	case single(SingleResult<Value, Failure>)
	case multiple(MultipleResult<Value, Failure>)
	
	public var summary: SingleResult<Value, Failure> {
		switch self {
		case .single(let singleResult):
			return singleResult
			
		case .multiple(let multipleResult):
			return multipleResult.summary
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

extension ProcessingResult {
	var failureResults: CompactResult<Failure>? {
		switch self {
		case .single(let singleResult):
			return singleResult.failureResult
		case .multiple(let multipleResult):
			return multipleResult.failureResults
		}
	}
}

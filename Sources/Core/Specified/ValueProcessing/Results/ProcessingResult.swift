public enum ProcessingResult <Value, Failure> {
	case single(SingleResult<Value, Failure>)
	indirect case multiple(MultipleResult<Value, Failure>)
	
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

public extension ProcessingResult where Failure: Error {
	func value () throws -> Value {
		switch summary.outcome {
		case .success(let value):
			return value
			
		case .failure(let error):
			throw error
		}
	}
}

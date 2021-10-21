public enum ProcessingState <Initial, Processing, Completed> {
	case initial(Initial)
	case processing(Processing)
	case completed(Completed)
	case failed(Error)
	
	public var stateName: String {
		switch self {
		case .initial:
			return "inital"
			
		case .processing:
			return "processing"
			
		case .completed:
			return "completed"
			
		case .failed:
			return "failed"
		}
	}
}

public extension ProcessingState where Initial == Void {
	init () {
		self = .initial()
	}
	
	static func initial () -> Self {
		.initial(Void())
	}
}

public extension ProcessingState where Processing == Void {
	static func processing () -> Self {
		.processing(Void())
	}
}

public extension ProcessingState where Completed == Void {
	static func completed () -> Self {
		.completed(Void())
	}
}

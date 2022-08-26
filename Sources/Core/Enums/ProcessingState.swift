public enum ProcessingState <Initial, Processing, Completed, Failed: Error> {
	case initial(Initial)
	case processing(Processing)
	case completed(Completed)
	case failed(Failed)
}

public extension ProcessingState {
	var stateName: String {
		switch self {
		case .initial:    return "inital"
		case .processing: return "processing"
		case .completed:  return "completed"
		case .failed:     return "failed"
		}
	}

	var initialValue: Initial?       { if case .initial(let value) = self { return value } else { return nil } }
	var processingValue: Processing? { if case .processing(let value) = self { return value } else { return nil } }
	var completedValue: Completed?   { if case .completed(let value) = self { return value } else { return nil } }
	var failedValue: Failed?         { if case .failed(let value) = self { return value } else { return nil } }

	var isInitial: Bool    { if case .initial = self { return true } else { return false } }
	var isProcessing: Bool { if case .processing = self { return true } else { return false } }
	var isCompleted: Bool  { if case .completed = self { return true } else { return false } }
	var isFailed: Bool     { if case .failed = self { return true } else { return false } }

	func mapInitial <NewInitial> (_ mapping: (Initial) -> NewInitial) -> ProcessingState<NewInitial, Processing, Completed, Failed> {
		switch self {
		case .initial(let v): return .initial(mapping(v))
		case .processing(let v): return .processing(v)
		case .completed(let v): return .completed(v)
		case .failed(let e): return .failed(e)
		}
	}

	func mapProcessing <NewProcessing> (_ mapping: (Processing) -> NewProcessing) -> ProcessingState<Initial, NewProcessing, Completed, Failed> {
		switch self {
		case .initial(let v): return .initial(v)
		case .processing(let v): return .processing(mapping(v))
		case .completed(let v): return .completed(v)
		case .failed(let e): return .failed(e)
		}
	}

	func mapCompleted <NewCompleted> (_ mapping: (Completed) -> NewCompleted) -> ProcessingState<Initial, Processing, NewCompleted, Failed> {
		switch self {
		case .initial(let v): return .initial(v)
		case .processing(let v): return .processing(v)
		case .completed(let v): return .completed(mapping(v))
		case .failed(let e): return .failed(e)
		}
	}

	func mapFailed <NewFailed: Error> (_ mapping: (Failed) -> NewFailed) -> ProcessingState<Initial, Processing, Completed, NewFailed> {
		switch self {
		case .initial(let v): return .initial(v)
		case .processing(let v): return .processing(v)
		case .completed(let v): return .completed(v)
		case .failed(let e): return .failed(mapping(e))
		}
	}
}

public extension ProcessingState where Initial == Void {
	init () { self = .initial() }
	
	static func initial () -> Self { .initial(Void()) }
}

public extension ProcessingState where Processing == Void {
	static func processing () -> Self { .processing(Void()) }
}

public extension ProcessingState where Completed == Void {
	static func completed () -> Self { .completed(Void()) }
}

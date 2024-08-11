extension LoadableValue: Equatable where Value: Equatable, LoadingTask: Equatable {
	public static func == (lhs: Self, rhs: Self) -> Bool {
		switch (lhs, rhs) {
		case (.initial, .initial): true
		case (.loading(let lTask, let lValue), .loading(let rTask, let rValue)): lTask == rTask && lValue == rValue
		case (.successful(let lValue), .successful(let rValue)): lValue == rValue
		case (.failed(let lError, let lValue), .failed(let rError, let rValue)): type(of: lError) == type(of: rError) && lValue == rValue
		default: false
		}
	}
}

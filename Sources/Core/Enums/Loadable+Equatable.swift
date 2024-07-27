extension LoadableValue: Equatable where Value: Equatable, LoadingTask: Equatable {
	public static func == (lhs: Self, rhs: Self) -> Bool {
		switch (lhs, rhs) {
		case (.initial, .initial): true
		case (.loading(let lLoading), .loading(let rLoading)): lLoading == rLoading
		case (.successful(let lValue), .successful(let rValue)): lValue == rValue
		case (.failed(let lError), .failed(let rError)): type(of: lError) == type(of: rError)
		default: false
		}
	}
}

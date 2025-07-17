public extension Result {
	var isSuccess: Bool {
		if case .success = self { true }
		else { false }
	}

	var isFailure: Bool {
		if case .failure = self { true }
		else { false }
	}
}

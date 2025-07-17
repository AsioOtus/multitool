public extension Result {
	var successValue: Success? {
		if case .success(let value) = self { value }
		else { nil }
	}

	var failureValue: Failure? {
		if case .failure(let value) = self { value }
		else { nil }
	}
}

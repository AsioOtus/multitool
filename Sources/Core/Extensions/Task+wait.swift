public extension Task {
	func wait () async {
		_ = await result
	}
}

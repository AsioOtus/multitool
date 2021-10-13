public struct DescribedError: DescribableError {
	public let description: String
	
	public init (_ description: String) {
		self.description = description
	}
}

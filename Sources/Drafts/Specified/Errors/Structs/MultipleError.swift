public struct MultipleError: MultipliableError {
	public let errors: [Error]
	
	public init (_ errors: [Error]) {
		self.errors = errors
	}
}

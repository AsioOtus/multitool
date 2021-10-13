public struct CascadeError: CascadableError {
	public let innerError: CascadableError?
	
	public init (_ innerError: CascadableError? = nil) {
		self.innerError = innerError
	}
}

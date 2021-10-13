public struct DetailedError<Details>: DetailazableError {
	public let details: Details
	
	public init (_ details: Details) {
		self.details = details
	}
}

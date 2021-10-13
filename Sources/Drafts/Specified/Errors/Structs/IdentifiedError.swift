public struct IdentifiedError: IdentifiableError {
	public typealias Identifier = UInt
	
	public var id: Identifier
	
	public init (_ id: UInt) {
		self.id = id
	}
}

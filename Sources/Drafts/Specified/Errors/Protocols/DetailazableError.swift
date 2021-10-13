public protocol DetailazableError: Error {
	associatedtype Details
	
	var details: Details { get }
}

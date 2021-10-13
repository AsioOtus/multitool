public protocol DescribableError: Error, CustomStringConvertible {
	var description: String { get }
}

public extension DescribableError {	
	var localizedDescription: String {
		return description
	}
}

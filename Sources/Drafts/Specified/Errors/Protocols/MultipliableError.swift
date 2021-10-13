public protocol MultipliableError: Error {
	var errors: [Error] { get }
	
	var allErrorsDescriptions: [String] { get }
	var fullErrorsDescription: String { get }
}

public extension MultipliableError {
	var allErrorsDescriptions: [String] {
		return errors.map { $0.localizedDescription }
	}
	
	var fullErrorsDescription: String {
		return errors.reduce("") { result, error in result + "\n" + error.localizedDescription }
	}
}

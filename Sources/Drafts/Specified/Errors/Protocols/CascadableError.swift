import Foundation

public protocol CascadableError: Error {
	var innerError: Error? { get }
	
	var allDescriptions: [String] { get }
	var fullDescription: String { get }
}

public extension CascadableError {
	var allDescriptions: [String] {
		return getAllInnerDescriptions()
	}
	
	var fullDescription: String {
		func addIndentation (for string: String, size: Int) -> String {
			let indentationString = String(repeating: "\t", count: size)
			return string.split(separator: "\n").map{ indentationString + $0 }.joined(separator: "\n")
		}
		
		return allDescriptions.enumerated().map{ addIndentation(for: $0.element, size: $0.offset) }.joined(separator: "\n\n")
	}
	
	private func getAllInnerDescriptions () -> [String] {
		var innerDescriptions = [String]()
		
		if let innerError = self.innerError as? CascadableError {
			innerDescriptions = innerError.allDescriptions
		} else if let innerError = self.innerError {
			innerDescriptions += [innerError.localizedDescription]
		}
		
		return [localizedDescription] + innerDescriptions
	}
}

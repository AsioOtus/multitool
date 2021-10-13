public protocol MultipleResultProtocol {
	associatedtype Value
	associatedtype Failure
	
	var results: [ProcessingResult<Value, Failure>] { get }
	var summaryResult: SingleResult<Value, Failure> { get }
}

public extension MultipleResultProtocol {
	var description: String {
		let resultsDescription = results
			.map{
				$0.description
					.split(separator: "\n")
					.map{ "    " + $0 }
					.joined(separator: "\n")
			}
			.joined(separator: "\n")
		
		return "\(summaryResult.description) {\(resultsDescription.isEmpty ? " " : "\n\(resultsDescription)\n")}"
	}
}

public struct MultipleResult <Value, Failure> {
	public let results: [ProcessingResult<Value, Failure>]
	public let summary: SingleResult<Value, Failure>
}

extension MultipleResult: CustomStringConvertible {
	public var description: String {
		let resultsDescription = results
			.map{
				$0.description
					.split(separator: "\n")
					.map{ "\t" + $0 }
					.joined(separator: "\n")
			}
			.joined(separator: "\n")
		
		return "\(summary.description) {\(resultsDescription.isEmpty ? " " : "\n\(resultsDescription)\n")}"
	}
}

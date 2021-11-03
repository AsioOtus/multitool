extension CompactResult {
	public enum Node {
		case single(Outcome)
		indirect case multiple([CompactResult], summary: Outcome?)
		
		public var summary: Outcome? {
			switch self {
			case .single(let single):
				return single
			case .multiple(_, let summary):
				return summary
			}
		}
		
		public var outcome: Outcome? {
			switch self {
			case .single(let outcome):
				return outcome
			case .multiple(_, let summary):
				return summary
			}
		}
	}
}

public struct CompactResult <Outcome> {
	public let node: Node
	public let type: String
	public let label: String?
	
	public var description: String {
		switch self.node {
		case .single(let outcome):
			return "\(type.uppercased())\(label.map{ " – \($0)" } ?? "") – \(outcome)"
		case .multiple(let results, let summary):
			let resultsDescription = results.map {
				$0.description
					.split(separator: "\n")
					.map{ "\t" + $0 }
					.joined(separator: "\n")
			}
			.joined(separator: "\n")
			
			return "\(type.uppercased())\(label.map{ " – \($0)" } ?? "")\(summary.map{ " – \($0)" } ?? "") {\(resultsDescription.isEmpty ? " " : "\n\(resultsDescription)\n")}"
		}
	}
}

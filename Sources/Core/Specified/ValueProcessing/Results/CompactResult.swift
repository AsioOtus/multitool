extension CompactResult {
	public struct Single {
		public let outcome: Outcome
		public let type: String
		public let label: String?
	}
}

public enum CompactResult <Outcome> {
	case single(Single)
	indirect case multiple([Self], summary: Single?)
	
	var summary: Single? {
		switch self {
		case .single(let single):
			return single
		case .multiple(_, let summary):
			return summary
		}
	}
}

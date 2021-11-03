extension SingleResult {
	public enum Outcome {
		case success(Value)
		case failure(Failure)
		
		public var isSuccess: Bool {
			switch self {
			case .success: return true
			case .failure: return false
			}
		}
		
		public var description: String {
			switch self {
			case .success(let value):
				return "SUCCESS(\(value))"
				
			case .failure(let failure):
				return "FAILURE(\(String(describing: failure)))"
			}
		}
	}
}

public struct SingleResult <Value, Failure> {
	public let outcome: Outcome
	public let type: String
	public let label: String?
	
	public var isSuccess: Bool { outcome.isSuccess }
	
	public init (_ outcome: Outcome, _ type: String, _ label: String? = nil) {
		self.outcome = outcome
		self.type = type
		self.label = label
	}
}

extension SingleResult: CustomStringConvertible {
	public var description: String { "\(type.uppercased())\(label.map{ $0.isEmpty ? "" : " – \($0)" } ?? ""): \(outcome.description)" }
}

public extension SingleResult {
	var failureResult: CompactResult<Failure>? {
		switch outcome {
		case .success(_):
			return nil
		case .failure(let failure):
			return .init(node: .single(failure), type: type, label: label)
		}
	}
}

public extension SingleResult where Failure: Error {
	func value () throws -> Value {
		switch outcome {
		case .success(let value):
			return value
			
		case .failure(let error):
			throw error
		}
	}
}

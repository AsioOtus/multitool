public extension SingleResult {
	enum Category {
		case success(Value)
		case failure(Failure? = nil)
		
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
				
			case .failure(.some(let failure)):
				return "FAILURE(\(String(describing: failure)))"
				
			case .failure(.none):
				return "FAILURE()"
			}
		}
	}
}

public struct SingleResult <Value, Failure> {
	public let category: Category
	public let typeName: String
	public let label: String?
	
	public var description: String { "\(typeName.uppercased())\(label.map{ $0.isEmpty ? "" : " – \($0)" } ?? ""): \(category.description)" }
	
	public init (_ category: Category, _ typeName: String, _ label: String? = nil) {
		self.category = category
		self.typeName = typeName
		self.label = label
	}
}

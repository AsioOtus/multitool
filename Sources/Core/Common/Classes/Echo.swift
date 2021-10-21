import Foundation

extension Echo {
	public struct Model: Codable {
		public static let dateFormatter: DateFormatter = {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss.SSSS"
			return dateFormatter
		}()
		
		public let date: String
		public let timestamp: Double
		public let info: [String: String]?
		public let processId: String
		
		public init (date: Date, info: [String: String]?, processId: String) {
			self.date = Self.dateFormatter.string(from: date)
			self.timestamp = date.timeIntervalSince1970
			self.info = info
			self.processId = processId
		}
	}
	
	struct Counter {
		private(set) var count = 0
		
		mutating func next () -> String {
			count += 1
			return String(count)
		}
	}
}

public class Echo {
	public static let standard = Echo()
	
	var counter = Counter()
}

public extension Echo {
	func ping () -> [String: Model] {
		["ping": model()]
	}
	
	func echo (_ phrase: String? = nil) -> [String: Model] {
		if let phrase = phrase {
			return ["echo": model(["phrase": phrase])]
		} else {
			return ["echo": model()]
		}
	}
	
	func pathTest (_ path: String) -> [String: Model] {
		["test": model(["path": path])]
	}
	
	func count () -> [String: Model] {
		["count": model(["number": counter.next()])]
	}
}

private extension Echo {
	func model (_ info: [String: String]? = nil) -> Model {
		.init(
			date: Date(),
			info: info,
			processId: String(ProcessInfo.processInfo.processIdentifier)
		)
	}
}

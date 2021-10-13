import Foundation

extension Echo {
	public struct Model {
		public let info: [String: String]?
		public let date: String
		public let processId: String
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
	
	static let dateFormatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm:ss dd.MM.yyyy"
		return dateFormatter
	}()
	
	var counter = Counter()
}

public extension Echo {
	func echo (_ phrase: String? = nil) -> [String: Model] {
		if let phrase = phrase {
			return ["echo": model(["phrase": phrase])]
		} else {
			return ["echo": model()]
		}
	}
	
	func test () -> [String: Model] {
		["test": model()]
	}
	
	func pathTest (_ path: String) -> [String: Model] {
		["test": model(["path": path])]
	}
	
	func count () -> [String: Model] {
		["count": model(["count": counter.next()])]
	}
}

private extension Echo {
	var date: String {
		let currentDate = Date()
		let formattedDate = Self.dateFormatter.string(from: currentDate)
		return formattedDate
	}
	
	var processId: String {
		String(ProcessInfo.processInfo.processIdentifier)
	}
	
	func model (_ info: [String: String]? = nil) -> Model {
		.init(info: info, date: date, processId: processId)
	}
}

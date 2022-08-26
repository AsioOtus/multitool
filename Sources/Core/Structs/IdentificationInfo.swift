import Foundation

public struct IdentificationInfo: Codable, CustomStringConvertible {
	public let module: String?
	public let type: String
	public let definition: String
	public let instance: String
	public let label: String?
	public let extra: String?
	
	public var description: String {
		"\(module.map{ "\($0)." } ?? "")\(type) – \(definition)\(label.map{ " – label: \($0)." } ?? "") – \(instance)\(extra.map{ " – \($0)" } ?? "")"
	}
	
	public var compactDescription: String {
		"\(module.map{ "\($0)." } ?? "")\(type) – \(instance)"
	}
	
	public var typeDescription: String {
		"\(module.map{ "\($0)." } ?? "")\(type)"
	}
	
	init (module: String? = nil, type: String, file: String, line: Int, label: String? = nil, extra: String? = nil) {
		self.module = module
		self.type = type
		self.definition = "\(file):\(line)"
		self.instance = UUID().uuidString
		self.label = label
		self.extra = extra
	}
}

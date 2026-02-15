public protocol CaseNamable {}

public extension CaseNamable {
	var caseName: String {
		Mirror(reflecting: self).children.first?.label ?? String(describing: self)
	}
}

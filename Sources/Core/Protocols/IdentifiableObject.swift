public protocol IdentifiableObject: AnyObject, Identifiable { }

public extension IdentifiableObject {
	var id: ObjectIdentifier { .init(self) }
}

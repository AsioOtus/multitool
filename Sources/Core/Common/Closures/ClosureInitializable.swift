public protocol ClosureInitializable { }

public extension ClosureInitializable where Self: EmptyInitializable {
    init (_ block: (inout Self) throws -> Void) rethrows {
		self.init()
		try block(&self)
	}
}

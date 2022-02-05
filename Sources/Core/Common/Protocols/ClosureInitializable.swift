public protocol ClosureInitializable { }

public extension ClosureInitializable where Self: EmptyInitializable {
    init (_ block: (inout Self) throws -> Void) rethrows {
		self.init()
		try block(&self)
	}
}

public extension ClosureInitializable where Self: AnyObject, Self: EmptyInitializable {
	init (_ block: (Self) throws -> Void) rethrows {
		self.init()
		try block(self)
	}
}

public protocol Fluentable { }

public extension Fluentable {
	func `do` (_ block: (Self) throws -> Void) rethrows {
		try block(self)
	}
	
	func use (_ block: (inout Self) throws -> Void) rethrows {
		var selfCopy = self
		try block(&selfCopy)
	}

	func set (_ block: (inout Self) throws -> Void) rethrows -> Self {
		var selfCopy = self
		try block(&selfCopy)
		return selfCopy
	}
	
	mutating func mutate (_ block: (inout Self) throws -> Void) rethrows {
		try block(&self)
	}
	
	func `let` <T> (_ block: (Self) throws -> T) rethrows -> T {
		try block(self)
	}
}

public extension Fluentable where Self: AnyObject {
	func set (_ block: (Self) throws -> Void) rethrows -> Self {
		try block(self)
		return self
	}
}

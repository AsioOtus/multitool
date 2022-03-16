public protocol Fluentable { }

public extension Fluentable {
    @discardableResult
	func use (_ block: (Self) throws -> Void) rethrows -> Self {
		try block(self)
        return self
	}
    
    @discardableResult
    func use (_ block: () throws -> Void) rethrows -> Self {
        try block()
        return self
    }
	
    @discardableResult
	func `do` (_ block: (inout Self) throws -> Void) rethrows -> Self {
		var selfCopy = self
		try block(&selfCopy)
        return self
	}
    
    @discardableResult
    mutating func mutate (_ block: (inout Self) throws -> Void) rethrows -> Self {
        try block(&self)
        return self
    }

	func set (_ block: (inout Self) throws -> Void) rethrows -> Self {
		var selfCopy = self
		try block(&selfCopy)
		return selfCopy
	}
	
	func `let` <T> (_ block: (Self) throws -> T) rethrows -> T {
		try block(self)
	}
    
    func `let` <T> (_ block: () throws -> T) rethrows -> T {
        try block()
    }
}

public extension Fluentable where Self: AnyObject {
	func set (_ block: (Self) throws -> Void) rethrows -> Self {
		try block(self)
		return self
	}
}

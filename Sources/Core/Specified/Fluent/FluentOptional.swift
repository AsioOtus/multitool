public extension Optional {
	@discardableResult
	func `if` (_ some: (Wrapped) -> Void, `else`: () -> Void = { }) -> Self {
		if let value = self { some(value) }
        else { `else`() }
		
		return self
	}
    
    @discardableResult
    func `if` (_ some: () -> Void, `else`: () -> Void = { }) -> Self {
        if self != nil { some() }
        else { `else`() }
        
        return self
    }
	
	@discardableResult
	func `else` (_ block: () -> Void) -> Self {
		if self == nil { block() }

		return self
	}
	
	func or (_ value: () -> Wrapped) -> Wrapped { self ?? value() }
	
	func or (_ value: Wrapped) -> Wrapped { self ?? value }
}

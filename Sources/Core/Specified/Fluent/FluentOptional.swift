public extension Optional {
	@discardableResult
	func `if` (_ action: (Wrapped) -> Void, `else`: () -> Void = { }) -> Self {
		if let value = self { action(value) }
        else { `else`() }
		
		return self
	}
    
    @discardableResult
    func `if` (_ action: () -> Void, `else`: () -> Void = { }) -> Self {
        if self != nil { action() }
        else { `else`() }
        
        return self
    }
	
	@discardableResult
	func `else` (_ action: () -> Void) -> Self {
		if self == nil { action() }

		return self
	}
	
	func or (_ value: () -> Wrapped) -> Wrapped { self ?? value() }
	
	func or (_ value: Wrapped) -> Wrapped { self ?? value }
}

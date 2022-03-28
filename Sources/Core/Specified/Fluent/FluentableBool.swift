public extension Bool {
    @discardableResult
    func `if` (_ action: () -> Void, `else`: () -> Void = { }) -> Self {
        if self { action() }
        else { `else`() }
        
        return self
    }
    
    @discardableResult
    func `else` (_ action: () -> Void) -> Self {
        if !self { action() }
        return self
    }
}


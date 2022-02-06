public extension Optional {
	@discardableResult
	public func `if` (_ some: (Wrapped) -> Void, `else`: () -> Void = { }) -> Self {
		if let value = self {
			some(value)
		} else {
			`else`()
		}
		
		return self
	}
	
	@discardableResult
	public func `else` (_ block: () -> Void) -> Self {
		if self == nil {
			block()
		}
		
		return self
	}
	
	public func mapNone (_ value: () -> Wrapped) -> Wrapped { self ?? value() }
	
	public func mapNone (_ value: Wrapped) -> Wrapped { self ?? value }
}

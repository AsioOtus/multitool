public func block (_ name: Any = "", _ block: () throws -> ()) rethrows {
	try block()
}

public func block <T> (_ name: Any = "", _ block: () throws -> (T)) rethrows -> T {
	return try block()
}

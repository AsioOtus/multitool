open class DelegatedCall<Input, Output> {
	public private(set) var callback: ((Input) -> Output?)?
	
	public func delegate <Object: AnyObject> (to object: Object, _ callback: @escaping (Object, Input) -> Output?) {
		self.callback = { [weak object] input in
			guard let object = object else { return nil }
			return callback(object, input)
		}
	}
}

public func weakCall <Object: AnyObject, Input, Output> (
	to object: Object,
	_ callback: @escaping (Object, Input) -> Output?
) -> (Input) -> Output? {
	{ [weak object] input in
		guard let object = object else { return nil }
		return callback(object, input)
	}
}

public func weakCall <Object: AnyObject, Output> (
	to object: Object,
	_ callback: @escaping (Object) -> Output?
) -> () -> Output? {
	{ [weak object] in
		guard let object = object else { return nil }
		return callback(object)
	}
}

//class Class { }
//
//let instance = Class()
//let call: () -> Void? = weakCall(to: instance) { weakInstance in
//
//}

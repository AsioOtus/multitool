import Foundation

public extension Event {
	typealias Handler = (Data) -> ()
}

public extension Event {
	enum HandlerAdditionResult {
		case added
		case keyExist
		case keyGenerated(String)
	}
}

open class Event<Data> {
	private var handlers = [String: Handler]()
	
	public required init () { }
	
	public func getHandler (byKey key: String) -> Handler? {
		return handlers[key]
	}
	
	@discardableResult public func addHandler (key: String? = nil, handler: @escaping Handler) -> HandlerAdditionResult {
		var additionResult: HandlerAdditionResult = .added
		
		let key = key ?? {
			let generatedKey = UUID().uuidString
			additionResult = .keyGenerated(generatedKey)
			return generatedKey
		}()
		
		let notContains = !contains(key: key)
		
		if notContains {
			handlers[key] = handler
		} else {
			additionResult = .keyExist
		}
		
		return additionResult
	}
	
	@discardableResult public func updateHandler (byKey key: String, handler: @escaping Handler) -> Bool {
		let isContains = contains(key: key)
		
		if isContains {
			handlers[key] = handler
		}
		
		return isContains
	}
	
	@discardableResult public func removeHandler (byKey key: String) -> Bool {
		let isContains = contains(key: key)
		
		if isContains {
			handlers.removeValue(forKey: key)
		}
		
		return isContains
	}
	
	public func contains (key: String) -> Bool {
		return handlers[key] != nil
	}
	
	public func clear () {
		handlers.removeAll()
	}
	
	public func raise (withData data: Data) {
		for (_, handler) in handlers {
			handler(data)
		}
	}
	
	public static func += (event: Event, handler: @escaping Handler) {
		event.addHandler(handler: handler)
	}
	
	public static func += (event: Event, handler: (key: String, block: Handler)) {
		event.addHandler(key: handler.key, handler: handler.block)
	}
}

extension Event where Data == Void {
	public func raise () {
		for (_, handler) in handlers {
			handler(Void())
		}
	}
}

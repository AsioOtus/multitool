public struct EnumDictionarySet<Enum, Value> where Enum: Hashable & CaseIterable {
	public private(set) var casesValues: [Enum: Value] = [:]
	
	public init () { }
	
	public subscript (key: Enum) -> Value? {
		get {
			let foundedValues = casesValues[key]
			return foundedValues
		}
		set (newValue) {
			casesValues[key] = newValue
		}
	}
}

extension EnumDictionarySet: Sequence {
	public typealias Iterator = DictionaryIterator<Enum, Value>
	
	public func makeIterator() -> Iterator {
		return casesValues.makeIterator()
	}
}

public extension EnumDictionarySet where Value == Optional<Any> {
	var notEmpties: [Enum: Value] {
		let notEmpties = casesValues.filter{ $0.value != nil }.mapValues{ $0! }
		return notEmpties
	}
}

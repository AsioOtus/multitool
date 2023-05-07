public struct KeyValuePair <Key, Value> {
	public let key: Key
	public let value: Value
	
	public init (_ key: Key, _ value: Value) {
		self.key = key
		self.value = value
	}
}

extension KeyValuePair: Equatable where Key: Equatable {
  public static func == (lhs: KeyValuePair<Key, Value>, rhs: KeyValuePair<Key, Value>) -> Bool {
    lhs.key == rhs.key
  }
}

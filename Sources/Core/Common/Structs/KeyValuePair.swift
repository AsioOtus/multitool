public struct KeyValuePair <Key, Value> {
	public let key: Key
	public let value: Value
	
	public init (_ key: Key, _ value: Value) {
		self.key = key
		self.value = value
	}
}

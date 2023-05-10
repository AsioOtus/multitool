public struct KeyValuePair <Key: Hashable, Value> {
  public let key: Key
  public let value: Value

  public init (_ key: Key, _ value: Value) {
    self.key = key
    self.value = value
  }
}

extension KeyValuePair: Hashable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.key == rhs.key
  }

  public func hash (into hasher: inout Hasher) {
    hasher.combine(key)
  }
}

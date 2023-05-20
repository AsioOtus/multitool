public struct Identified <ID: Hashable, Value> {
  public let id: ID
  public let value: Value

  public init (_ id: ID, _ value: Value) {
    self.id = id
    self.value = value
  }
}

extension Identified: Identifiable { }

extension Identified: Hashable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.id == rhs.id
  }

  public func hash (into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

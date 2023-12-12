extension Result: Codable where Success: Codable, Failure: Codable {
  private enum CodingKeys: String, CodingKey {
    case success
    case failure
  }

  public init (from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    do {
      self = .success(try container.decode(Success.self, forKey: .success))
    } catch {
			guard !container.contains(.success) else { throw error }
      self = .failure(try container.decode(Failure.self, forKey: .failure))
    }
  }

  public func encode (to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    switch self {
    case .success(let payload):
      try container.encode(payload, forKey: .success)

    case .failure(let payload):
      try container.encode(payload, forKey: .failure)
    }
  }
}

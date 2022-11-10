extension Result: Codable where Success: Codable, Failure: Codable {
	private enum CodingKeys: String, CodingKey {
		case base
		case payload
	}

	private enum Base: String, Codable {
		case success
		case failure
	}

	public init (from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let base = try container.decode(Base.self, forKey: .base)

		switch base {
		case .success:
			self = .success(try container.decode(Success.self, forKey: .payload))
		case .failure:
			self = .failure(try container.decode(Failure.self, forKey: .payload))
		}
	}

	public func encode (to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		switch self {
		case .success(let payload):
			try container.encode(Base.success, forKey: .base)
			try container.encode(payload, forKey: .payload)
		case .failure(let payload):
			try container.encode(Base.failure, forKey: .base)
			try container.encode(payload, forKey: .payload)
		}
	}
}

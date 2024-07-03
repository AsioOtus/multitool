import Foundation

public extension UUID {
	static func create () -> Self { create(0, 0, 0, 0, 0) }
  static func create (_ e: Int) -> Self { create(0, 0, 0, 0, e) }
  static func create (_ d: Int, _ e: Int) -> Self { create(0, 0, 0, d, e) }
  static func create (_ c: Int, _ d: Int, _ e: Int) -> Self { create(0, 0, c, d, e) }
  static func create (_ b: Int, _ c: Int, _ d: Int, _ e: Int) -> Self { create(0, b, c, d, e) }

  static func create (_ a: Int, _ b: Int, _ c: Int, _ d: Int, _ e: Int) -> Self {
    func pad (_ int: Int, size: Int) -> String {
      String(int).padded(atStartTo: size, with: "0")
    }

    return .init(uuidString: "\(pad(a, size: 8))-\(pad(b, size: 4))-\(pad(c, size: 4))-\(pad(d, size: 4))-\(pad(e, size: 12))")!
  }
}

public extension UUID {
	static let zeros = Self(uuidString: "00000000-0000-0000-0000-000000000000")!
}

import Foundation

public extension UUID {
  static func create (_ e: Int) -> Self? { create(0, 0, 0, 0, e) }
  static func create (_ d: Int, _ e: Int) -> Self? { create(0, 0, 0, d, e) }
  static func create (_ c: Int, _ d: Int, _ e: Int) -> Self? { create(0, 0, c, d, e) }
  static func create (_ b: Int, _ c: Int, _ d: Int, _ e: Int) -> Self? { create(0, b, c, d, e) }
	static func create (_ a: Int, _ b: Int, _ c: Int, _ d: Int, _ e: Int) -> Self? { create(a: a, b: b, c: c, d: d, e: e) }

	static func create (
		a: Int = 0,
		b: Int = 0,
		c: Int = 0,
		d: Int = 0,
		e: Int = 0
	) -> Self? {
		create(
			a: a.description,
			b: b.description,
			c: c.description,
			d: d.description,
			e: e.description
		)
  }
}

public extension UUID {
	static func create (_ e: String) -> Self? { create("0", "0", "0", "0", e) }
	static func create (_ d: String, _ e: String) -> Self? { create("0", "0", "0", d, e) }
	static func create (_ c: String, _ d: String, _ e: String) -> Self? { create("0", "0", c, d, e) }
	static func create (_ b: String, _ c: String, _ d: String, _ e: String) -> Self? { create("0", b, c, d, e) }
	static func create (_ a: String, _ b: String, _ c: String, _ d: String, _ e: String) -> Self? { create(a: a, b: b, c: c, d: d, e: e) }

	static func create (
		a: String = "0",
		b: String = "0",
		c: String = "0",
		d: String = "0",
		e: String = "0"
	) -> Self? {
		func pad (_ component: String, _ size: Int) -> String {
			component.padded(atStartTo: size, with: "0")
		}

		let uuidString = "\(pad(a, 8))-\(pad(b, 4))-\(pad(c, 4))-\(pad(d, 4))-\(pad(e, 12))"

		return .init(uuidString: uuidString)
	}
}


public extension UUID {
	static let zeros = Self(uuidString: "00000000-0000-0000-0000-000000000000")!
}

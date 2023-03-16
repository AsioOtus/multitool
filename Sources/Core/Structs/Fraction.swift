import Foundation

public struct Fraction {
  public let numerator: Int
  public let denominator: Int

  public init () {
    self.init(numerator: 0, denominator: 1)
  }

  public init (numerator: Int) {
    self.init(numerator: numerator, denominator: 1)
  }

  public init (reciprocalOf denominator: Int) {
    self.init(numerator: 1, denominator: denominator)
  }

  public init (decimal x0: Double, withPrecision eps : Double = 1.0E-6) {
    let (numerator, denominator) = Self.rationalApproximation(of: x0, withPrecision: eps)
    self.init(numerator: numerator, denominator: denominator)
  }

  public init (numerator: Int, denominator: Int) {
    self.numerator = numerator;
    self.denominator = denominator;
  }
}

public extension Fraction {
  func reduce () -> Self {
    let gcd = Self.gcd(numerator, denominator)
    return .init(numerator: numerator / gcd, denominator: denominator / gcd)
  }

  func tuple () -> (numerator: Int, denominator: Int) {
    (self.numerator, self.denominator)
  }
}

private extension Fraction {
  static func gcd (_ a: Int, _ b: Int) -> Int {
    b == 0 ? a : gcd(b, a % b)
  }

  static func gcd (_ vector: [Int]) -> Int {
    vector.reduce(0, gcd)
  }

  static func gcd (of vector: Int...) -> Int {
    gcd(vector)
  }

  static func lcm (_ a: Int, _ b: Int) -> Int {
    a / gcd(a, b) * b
  }

  static func lcm (_ vector: [Int]) -> Int {
    vector.reduce(1, lcm)
  }

  static func lcm (of vector: Int...) -> Int {
    lcm(vector)
  }

  static func rationalApproximation (of x0 : Double, withPrecision eps : Double = 1.0E-6) -> (numerator: Int, denominator: Int) {
    var x = x0
    var a = floor(x)
    var (h1, k1, h, k) = (1, 0, Int(a), 1)

    while x - a > eps * Double(k) * Double(k) {
      x = 1.0/(x - a)
      a = floor(x)
      (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
    }

    return (numerator: h, denominator: k)
  }
}

public extension Fraction {
  static func + (first: Self, second: Self) -> Self {
    let numerator = (first.numerator * second.denominator) + (first.denominator * second.numerator)
    let denominator = (first.denominator * second.denominator)
    return .init(numerator: numerator, denominator: denominator).reduce()
  }

  static func - (first: Self, second: Self) -> Self {
    first + Self(numerator: -second.numerator, denominator: second.denominator)
  }

  static func * (first: Self, second: Self) -> Self {
    let numerator = first.numerator * second.numerator
    let denominator = first.denominator * second.denominator
    return .init(numerator: numerator, denominator: denominator).reduce()
  }

  static func / (first: Self, second: Self) -> Self {
    first * Self(numerator: second.denominator, denominator: second.numerator)
  }
}

public extension Fraction {
  static func commonDenominator (of fractions: [Self]) -> [Self] {
    let commonDenominator = lcm(fractions.map { $0.denominator })
    let numerators = fractions.map { $0.numerator * commonDenominator / $0.denominator }
    return numerators.map { .init(numerator: $0, denominator: commonDenominator) }
  }

  static func commonDenominator (of fractions: Self...) -> [Self] {
    commonDenominator(of: fractions)
  }
}

extension Fraction: CustomStringConvertible {
  public var description: String { "\(numerator)/\(denominator)" }
}

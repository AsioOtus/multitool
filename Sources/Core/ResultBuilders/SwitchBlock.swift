@resultBuilder
struct SwitchBlock {
  static func buildBlock <T> (_ t: T) -> T { t }
  static func buildEither <T> (first: T) -> T { first }
  static func buildEither <T> (second: T) -> T { second }
}

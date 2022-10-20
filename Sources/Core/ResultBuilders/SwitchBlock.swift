@resultBuilder
public struct SwitchBlock {
  public static func buildBlock <T> (_ t: T) -> T { t }
  public static func buildEither <T> (first: T) -> T { first }
  public static func buildEither <T> (second: T) -> T { second }
}

public struct EmptyError: Error {
    public static let `default` = Self()

    public init () { }
}

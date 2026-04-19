public extension Error {
    static func ignore <T> (_ action: () throws -> T?) throws -> T? {
        do {
            return try action()
        }
        catch is Self { return nil }
        catch { throw error }
    }
}

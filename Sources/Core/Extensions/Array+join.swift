public extension Array {
    func join (_ lhs: Self?, _ rhs: Self?) -> Self? {
        switch (lhs, rhs) {
        case (.none, .none): nil
        case (.none, _): rhs
        case (_, .none): lhs
        case (.some(let lhs), .some(let rhs)): lhs + rhs
        }
    }
}

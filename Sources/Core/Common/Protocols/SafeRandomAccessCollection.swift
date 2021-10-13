protocol SafeRandomAccessCollection where Self: Collection {
    subscript (safe index: Self.Index) -> Element? { get }
}

extension SafeRandomAccessCollection {
    subscript (safe index: Self.Index) -> Element? {
        get {
            guard index <= self.endIndex else { return nil }
            return self[index]
        }
    }
}

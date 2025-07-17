public func address (_ object: AnyObject) -> String {
    Unmanaged.passUnretained(object).toOpaque().debugDescription
}

public protocol PTask {
    func wait () async
}

extension Task: PTask {
    public func wait () async {
        _ = await self.result
    }
}

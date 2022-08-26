import Foundation

struct DispatchArray {
    let queue: DispatchQueue

    init (_ queue: DispatchQueue = .init(label: UUID().uuidString, attributes: .concurrent)) {
        self.queue = queue
    }
    
    private func write (action: @escaping () -> ()) {
        queue.async(flags: .barrier, execute: action)
    }
    
    private func read (action: () -> ()) {
        queue.sync(execute: action)
    }
}

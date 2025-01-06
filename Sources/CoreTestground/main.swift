import Foundation
import Multitool
import Combine

public typealias CancellableLoadable<Value> = LoadableValue<Value, Error, Cancellable>

var l = CancellableLoadable<String>.initial

let j = Just("123")
    .delay(for: .seconds(5), scheduler: DispatchQueue.main)
    .sink {
        print($0)
    } receiveValue: {
        print($0)
    }
    .store(in: &l)

l.cancel()

RunLoop.main.run()

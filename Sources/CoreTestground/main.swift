import Multitool
import Combine

typealias Loadable<Value> = LoadableValue<Value, Error, AnyCancellable>

var l = Loadable<String>.loading()
l.cancel()

let a = Just(()).sink { }
a.store(in: &l)
//a.kek

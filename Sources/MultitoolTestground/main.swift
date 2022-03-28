import Multitool

let someBoolVariableWithVeryLongName = true

func a (_ b: (() -> Void) -> () -> Void) -> Void { b {  }() } //(() -> Void) -> () { { $0() } }

a { (b: @escaping () -> Void) in { b() } }

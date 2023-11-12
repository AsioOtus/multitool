import Multitool

let processable = Processable<Int, String, Double, Error>.initial(0)


_ = processable.replaceInitialValue(with: "qwe")
_ = processable.replaceInitial(with: .processing("123"))

import Multitool

let processable = Processable<Int, String, Double, Error>.initial(0)
let a = processable.replaceInitial { a in .processing("qwe") }

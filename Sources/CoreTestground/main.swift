import Multitool

var processable = Processable<Int, String, Double, Error>.initial(0)


_ = processable.replaceInitialValue(with: "qwe")
_ = processable.replaceInitial(with: .processing("123"))

let result = Result<Double, Error>.success(123.5)

//processable.set(result: result)
processable.replace(with: result)

let processable2 = result.processable()


var l = Loadable<String>.initial()
await l.setLoading {
	Task {
		""
	}
}

let l2 = await Loadable<String>.loading {
	Task {
		"qwe"
	}
}

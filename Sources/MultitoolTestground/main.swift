import Combine
import Foundation



if #available(macOS 10.15, *) {
	var s = Set<AnyCancellable>()

	let a = PassthroughSubject<String, Never>()

	let b = a.eraseToAnyPublisher()

	b.sink { print($0) }
		.store(in: &s)

	a.send("qeqweqew")

	RunLoop.main.run()
}

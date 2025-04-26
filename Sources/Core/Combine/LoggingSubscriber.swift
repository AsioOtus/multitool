import Combine
import Foundation

func testLogSubscriber () {
    let s = PassthroughSubject<String, Error>()
    let ls = s.log()

    s.send("START")
    s.send("111")
    s.send("222")
    s.send("333")
    s.send("444")
    s.send("555")
    s.send("END")
    s.send(completion: .finished)

    print(ls)
}

public class LoggingSubscriber <Output, Failure: Error> {
    private var lock = NSLock()

    private(set) var values = [Output]()
    private(set) var completion: Subscribers.Completion<Failure>?
    private(set) var subscription: Subscription?

    public var firstValue: Output? { values.first }
    public var lastValue: Output? { values.last }

    public var failure: Failure? {
        if case .failure(let failure) = completion { failure } else { nil }
    }

    public var isCompleted: Bool { completion != nil }
    public var isFailed: Bool { failure != nil }

    public init () { }

    func clearValues () {
        values = []
    }
}

extension LoggingSubscriber: Subscriber {
    public func receive (subscription: any Subscription) {
        lock.lock()

        guard self.subscription == nil else {
            lock.unlock()
            subscription.cancel()
            return
        }

        self.subscription = subscription
        lock.unlock()

        subscription.request(.unlimited)
    }

    public func receive (_ input: Output) -> Subscribers.Demand {
        lock.lock()
        values.append(input)
        lock.unlock()

        return .none
    }

    public func receive (completion: Subscribers.Completion<Failure>) {
        lock.withLock {
            self.completion = completion
        }
    }
}

extension LoggingSubscriber: Cancellable {
    public func cancel() {
        lock.lock()
        let subscription = subscription
        self.subscription = nil
        lock.unlock()

        subscription?.cancel()
    }
}

extension LoggingSubscriber: CustomStringConvertible {
    public var description: String {
        """
        First value: \(firstValue.unwrappedDescription)
        Last value: \(lastValue.unwrappedDescription)
        Values count: \(values.count)
        Completion: \(completion.unwrappedDescription)
        Subscription: \(subscription.unwrappedDescription)
        """
    }
}

fileprivate extension Optional {
    var unwrappedDescription: String {
        self.map(String.init(describing:)) ?? "nil"
    }
}

public extension Publisher {
    func log () -> LoggingSubscriber<Output, Failure> {
        let subsriber = LoggingSubscriber<Output, Failure>()
        self.subscribe(subsriber)
        return subsriber
    }
}

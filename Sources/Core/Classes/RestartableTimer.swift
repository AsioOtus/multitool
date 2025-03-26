import Combine
import Foundation

extension RestartableTimer {
    public enum Event {
        case tick(Date)
        case stop

        public var isTick: Bool {
            if case .tick = self { true }
            else { false }
        }

        public var isStop: Bool {
            if case .stop = self { true }
            else { false }
        }

        public var date: Date? {
            if case .tick(let date) = self { date }
            else { nil }
        }
    }
}

public class RestartableTimer {
    private var subscription: AnyCancellable?
    private let subject = PassthroughSubject<Event, Never>()

    public let interval: TimeInterval
    public let tolerance: TimeInterval?
    public let runLoop: RunLoop
    public let runLoopMode: RunLoop.Mode
    public let options: RunLoop.SchedulerOptions?

    public init (
        interval: TimeInterval,
        tolerance: TimeInterval? = nil,
        runLoop: RunLoop = .main,
        runLoopMode: RunLoop.Mode = .default,
        options: RunLoop.SchedulerOptions? = nil
    ) {
        self.interval = interval
        self.tolerance = tolerance
        self.runLoop = runLoop
        self.runLoopMode = runLoopMode
        self.options = options
    }

    private var timer: AnyPublisher<Event, Never> {
        Timer
            .publish(
                every: interval,
                tolerance: tolerance,
                on: runLoop,
                in: runLoopMode,
                options: options
            )
            .autoconnect()
            .map(Event.tick)
            .eraseToAnyPublisher()
    }

    public func start () {
        stop()
        subscription = timer.subscribe(subject)
    }

    public func start (till endDate: Date) {
        stop()
        subscription = timer
            .sink { [weak self] in
                if let date = $0.date, date <= endDate {
                    self?.subject.send($0)
                } else {
                    self?.stop()
                }
            }
    }

    public func start (tick count: Int) {
        stop()
        subscription = timer
            .scan((Event.tick(.init()), 0)) { ($1, $0.1 + 1) }
            .sink { [weak self] (date, tick) in
                if tick <= count {
                    self?.subject.send(date)
                } else {
                    self?.stop()
                }
            }
    }

    public func stop () {
        subject.send(.stop)
        subscription?.cancel()
        subscription = nil
    }
}

extension RestartableTimer: Publisher {
    public typealias Output = RestartableTimer.Event
    public typealias Failure = Never

    public func receive<S> (subscriber: S) where S : Subscriber, Never == S.Failure, Event == S.Input {
        subject.receive(subscriber: subscriber)
    }
}

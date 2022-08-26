import Foundation
import os.log



protocol MTTimerLoggingProvider {
	func log (timerEvent: MTTimer.Event)
}



extension MTTimer {
	enum Event: Equatable {
		case started(Int)
		case stopped
		case expired
		case warning(Int)
		case step(Int)
		
		var logMessage: String {
			let message: String
			
			switch self {
			case .started(let remainingSeconds):
				message = "Started – \(remainingSeconds)"
			case .stopped:
				message = "Stopped"
			case .expired:
				message = "Expired"
			case .warning(let remainingSeconds):
				message = "Warning – \(remainingSeconds)"
			case .step(let remainingSeconds):
				message = "Step – \(remainingSeconds)"
			}
			
			return message
		}
	}
}



extension MTTimer {
	struct DefaultLoggingProvider: MTTimerLoggingProvider {
		public var prefix: String?
		public var logSteps: Bool
		public var level: OSLogType
		
		public init (prefix: String? = nil, logSteps: Bool = false, level: OSLogType = .default) {
			self.prefix = prefix
			self.logSteps = logSteps
			self.level = level
		}
		
		public func log (timerEvent: MTTimer.Event) {
			if case .step(_) = timerEvent { return }
			
			let log = OSLog(subsystem: "MTTimer", category: "MTTimer")
			
			let prefix = self.prefix ?? ""
			let preparedPrefix = !prefix.isEmpty
				? "\(prefix)."
				: ""
			
			let message = "\(preparedPrefix)MTTimer – \(timerEvent.logMessage)"
			
			os_log("%{public}@", log: log, type: level, message)
		}
	}
}



class MTTimer {
	static var loggingProvider: MTTimerLoggingProvider?
	
	var isExpired: Bool? {
		guard let remainingSeconds = remainingSeconds else { return nil }
		
		let isExpired = remainingSeconds < 0
		return isExpired
	}
	
	private var remainingSeconds: Int? {
		guard let endTime = endTime else { return nil }
		
		let remainingTime = (endTime.timeIntervalSinceReferenceDate - Date().timeIntervalSinceReferenceDate).rounded(.toNearestOrAwayFromZero)
		
		let remainingSeconds =  Int(remainingTime)
		return remainingSeconds
	}
	
	private var timer: Timer?
	private let intervalSeconds: Int
	
	private var startTime: Date?
	private var endTime: Date?
	
	private var warningSeconds = [Int: Bool]()
	
	private var secondsChangedCallbacks: [(Int) -> ()] = []
	private var secondsWarningCallbacks: [(Int) -> ()] = []
	private var secondsExpiredCallbacks: [() -> ()] = []
	
	init (intervalSeconds: Int = 1, warningSeconds: Set<Int> = [], loggingProvider: MTTimerLoggingProvider = DefaultLoggingProvider()) {
		self.intervalSeconds = intervalSeconds
		
		for warningSecond in warningSeconds {
			self.warningSeconds[warningSecond] = false
		}
	}
	
	func start (_ seconds: Int) {
		stop()
		
		startTime = Date()
		endTime = startTime?.addingTimeInterval(TimeInterval(seconds))
		warningSeconds.keys.forEach { warningSeconds[$0] = false }
		
		let timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(intervalSeconds), repeats: true, block: stepHandler)
		timer.tolerance = 0.2
		RunLoop.current.add(timer, forMode: .common)
		
		guard let remainingSeconds = remainingSeconds else { return }
		
		MTTimer.loggingProvider?.log(timerEvent: .started(remainingSeconds))
		
		for callback in secondsChangedCallbacks {
			callback(remainingSeconds)
		}
	}
	
	func stop () {
		timer?.invalidate()
		
		timer = nil
		
		startTime = nil
		endTime = nil
		warningSeconds.keys.forEach { warningSeconds[$0] = false }
		
		MTTimer.loggingProvider?.log(timerEvent: .stopped)
	}
	
	func subscribeForSecondsChanges (_ callback: @escaping (Int) -> ()) {
		secondsChangedCallbacks.append(callback)
		
		if let remainingSeconds = remainingSeconds {
			callback(remainingSeconds)
		}
	}
	
	func subscribeForWarning (_ callback: @escaping (Int) -> ()) {
		secondsWarningCallbacks.append(callback)
	}
	
	func subscribeForSecondsExpiration (_ callback: @escaping () -> ()) {
		secondsExpiredCallbacks.append(callback)
	}
	
	private func stepHandler (_ timer: Timer) {
		guard let remainingSeconds = remainingSeconds else { return }
		
		MTTimer.loggingProvider?.log(timerEvent: .step(remainingSeconds))
		
		if isExpired == true {
			MTTimer.loggingProvider?.log(timerEvent: .expired)
			
			for callback in secondsExpiredCallbacks {
				callback()
			}
			
			stop()
			
			return
		}
		
		for (warningSecond, isAlreadyWarned) in warningSeconds {
			if remainingSeconds < warningSecond && !isAlreadyWarned {
				warningSeconds[warningSecond] = true
				
				MTTimer.loggingProvider?.log(timerEvent: .warning(remainingSeconds))
				
				for callback in secondsWarningCallbacks {
					callback(remainingSeconds)
				}
			}
		}
		
		for callback in secondsChangedCallbacks {
			callback(remainingSeconds)
		}
	}
}

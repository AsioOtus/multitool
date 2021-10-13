import Foundation

public class DispatchResetableFirst {
	private(set) var isReady = false
	
	private let semaphore = DispatchSemaphore(value: 1)
	
	public init () { }
	
	public func perform (_ action: () -> Void) {
		semaphore.wait()
		
		guard !isReady else {
			semaphore.signal()
			return
		}
		
		isReady = true
		semaphore.signal()
		
		action()
	}
	
	public func reset () {
		semaphore.wait()
		
		isReady = false
		
		semaphore.signal()
	}
}

import Foundation

public class DispatchSingle {
	private(set) var isFree = true
	
	private let semaphore = DispatchSemaphore(value: 1)
	
	public init () { }
	
	public func perform (_ action: @escaping () -> Void) {
		semaphore.wait()
		
		if !isFree {
			semaphore.signal()
			return
		}
		
		isFree = false
		semaphore.signal()
		
		action()
		
		isFree = true
	}
	
	public func perform (_ action: @escaping (_ completion: @escaping () -> Void) -> Void) {
		semaphore.wait()
		
		if !isFree {
			semaphore.signal()
			return
		}
		
		isFree = false
		semaphore.signal()
		
		action {
			self.isFree = true
		}
	}
}

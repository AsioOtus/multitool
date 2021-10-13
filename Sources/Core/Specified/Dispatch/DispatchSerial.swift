import Foundation

public class DispatchSerial {
	private let semaphore = DispatchSemaphore(value: 1)
	
	public init () { }
	
	public func perform (_ action: () -> Void) {
		semaphore.wait()
		
		action()
		
		semaphore.signal()
	}
	
	public func perform (_ action: (_ completion: @escaping () -> Void) -> Void) {
		semaphore.wait()
		
		action {
			self.semaphore.signal()
		}
	}
}

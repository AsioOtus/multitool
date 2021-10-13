import Foundation

public class DispatchWait {
	private init () { }
	
	public static func `for` (_ interval: DispatchTimeInterval) {
		_ = DispatchSemaphore(value: 0).wait(timeout: DispatchTime.now() + interval)
	}
}

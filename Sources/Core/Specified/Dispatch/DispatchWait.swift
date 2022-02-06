import Foundation

public class DispatchWait {
	private init () { }
	
	public static func `for` (_ interval: DispatchTimeInterval) {
		_ = DispatchSemaphore(value: 0).wait(timeout: DispatchTime.now() + interval)
	}
	
	public static func `for` (_ seconds: Int) {
		_ = DispatchSemaphore(value: 0).wait(timeout: DispatchTime.now() + .seconds(seconds))
	}
}

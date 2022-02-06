import Foundation

public extension DispatchQueue {
	func after (_ delay: DispatchTimeInterval, do block: @escaping () -> ()) {
		asyncAfter(deadline: DispatchTime.now() + delay, execute: block)
	}
	
	func after (_ seconds: Int, do block: @escaping () -> ()) {
		asyncAfter(deadline: DispatchTime.now() + .seconds(seconds), execute: block)
	}
}

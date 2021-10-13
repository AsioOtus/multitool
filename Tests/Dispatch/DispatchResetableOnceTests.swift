import XCTest
import MultitoolBase

class DispatchResetableOnceTests: XCTestCase {
	func testDefaultCase () {
		var counter = 0
		let dispatchOnce = DispatchResetableOnce {
			counter += 1
		}
		
		DispatchQueue.concurrentPerform(iterations: 100) { i in
			dispatchOnce.perform()
		}
		
		XCTAssert(counter == 1, "Unexpected counter value | Actual value – \(counter) | Expected – 1")
		
		dispatchOnce.reset()
		
		DispatchQueue.concurrentPerform(iterations: 100) { i in
			dispatchOnce.perform()
		}
		
		XCTAssert(counter == 2, "Unexpected counter value | Actual value – \(counter) | Expected – 2")
	}
}

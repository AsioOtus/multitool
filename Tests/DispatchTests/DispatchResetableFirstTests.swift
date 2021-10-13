import XCTest
@testable import Multitool

class DispatchResetableFirstTests: XCTestCase {
	func testDefaultCase () {
		var counter = 0
		let dispatchFirst = DispatchResetableFirst()
		
		DispatchQueue.concurrentPerform(iterations: 100) { i in
			dispatchFirst.perform {
				counter += 1
			}
		}
		
		XCTAssert(counter == 1, "Unexpected counter value | Actual value – \(counter) | Expected – 1")

		dispatchFirst.reset()
		
		DispatchQueue.concurrentPerform(iterations: 100) { i in
			dispatchFirst.perform {
				counter += 1
			}
		}
		
		XCTAssert(counter == 2, "Unexpected counter value | Actual value – \(counter) | Expected – 2")
	}
}

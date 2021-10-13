import XCTest
@testable import Multitool

class DispatchFirstTests: XCTestCase {
	func testDefaultCase () {
		var counter = 0
		let dispatchFirst = DispatchFirst()
		
		DispatchQueue.concurrentPerform(iterations: 100) { i in
			dispatchFirst.perform {
				counter += 1
			}
		}
		
		XCTAssert(counter == 1, "Unexpected counter value | Actual value – \(counter) | Expected – 1")
	}
}

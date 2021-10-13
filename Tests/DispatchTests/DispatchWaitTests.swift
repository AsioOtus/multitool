import XCTest
@testable import Multitool

class DispatchWaitTests: XCTestCase {
	func testDelay () {
		let delay = 3
		
		let startDate = Date().timeIntervalSince1970
		DispatchWait.for(.seconds(delay))
		let endDate = Date().timeIntervalSince1970
							
		let difference = endDate - startDate
		print("Difference: \(difference)")
		
		XCTAssert(difference >= Double(delay) && difference < Double(delay) + 0.005, "Unexpected delay | Actual value – \(difference) seconds | Expected – \(delay) ± 0.005 seconds")
	}
	
	func testDelayValue () {
		let delay = 3
		
		measure {
			DispatchWait.for(.seconds(delay))
		}
	}
}

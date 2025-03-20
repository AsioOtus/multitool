import XCTest

@testable import Multitool

final class UUIDCreateTest: XCTestCase {
	func test_int () {
		// When
		let uuid = UUID.create(Int.max, Int.max, Int.max, Int.max, Int.max)

		// Then
		XCTAssertEqual(uuid, nil)
	}

	func test_string () {
		// When
		let uuid = UUID.create("aaaaaaaaaaaabbbb")

		// Then
		let expectedUuid = UUID(uuidString: "00000000-0000-0000-0000-aaaaaaaaaaaa")!
		XCTAssertEqual(uuid, nil)
	}
}

import XCTest

@testable import Multitool

final class SequenceTests: XCTestCase {
	func test_duplicatesRemoved_withProperty () {
		// Given
		struct Test: Equatable {
			let id: Int
			let value: String
		}

		let arrayWithDuplicates: [Test] = [
			.init(id: 0, value: "1"),
			.init(id: 1, value: "2"),
			.init(id: 2, value: "3"),
			.init(id: 3, value: "2"),
			.init(id: 4, value: "1"),
			.init(id: 0, value: "4"),
			.init(id: 1, value: "5"),
		]

		// When
		let uniqueArray = arrayWithDuplicates.duplicatesRemoved(\.id)

		// Then
		let expectedArray: [Test] = [
			.init(id: 0, value: "1"),
			.init(id: 1, value: "2"),
			.init(id: 2, value: "3"),
			.init(id: 3, value: "2"),
			.init(id: 4, value: "1"),
		]

		XCTAssertEqual(uniqueArray, expectedArray)
	}
}

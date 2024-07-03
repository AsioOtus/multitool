import XCTest

@testable import Multitool

final class PathTests: XCTestCase {
	func test_iteration () async throws {
		// Given
		let path: Path = ["c1", "c2", "c3"]
		var components = [String]()

		// When
		for component in path {
			components.append(component)
		}

		// Then
		XCTAssertEqual(components, path.components)
	}

	func test_initFromString () {
		// Given
		let string = "c1.c2.c3"

		// When
		let path = Path(string, splitBy: ".")

		// Then
		XCTAssertEqual(path.components, ["c1", "c2", "c3"])
		XCTAssertEqual(path.description, string)
	}

	func test_initFromStringWithEmptyTrailing () {
		// Given
		let string = "c1.c2.c3"
		let testString = string + "."

		// When
		let path = Path(testString, splitBy: ".")

		// Then
		XCTAssertEqual(path.components, ["c1", "c2", "c3"])
		XCTAssertEqual(path.description, string)
	}
}

import MultitoolTesting
import XCTest

@testable import Multitool

final class FixedWidthIntegerRotationTests: XCTestCase {
	let given = 0b00100110

	func test_1_6 () {
		let actual = given.rotate(by: 1, modulus: 6)

		let expected = 0b00001101
		XCTAssertEqual(actual, expected)
	}

	func test_2_6 () {
		let actual = given.rotate(by: 2, modulus: 6)

		let expected = 0b00011010
		XCTAssertEqual(actual, expected)
	}

	func test_1_4 () {
		let actual = given.rotate(by: 1, modulus: 4)

		let expected = 0b00001100
		XCTAssertEqual(actual, expected)
	}

	func test_2_4 () {
		let actual = given.rotate(by: 2, modulus: 4)

		let expected = 0b00001001
		XCTAssertEqual(actual, expected)
	}

	func test_3_4 () {
		let actual = given.rotate(by: 3, modulus: 4)

		let expected = 0b00000011
		XCTAssertEqual(actual, expected)
	}

	func test_4_4 () {
		let actual = given.rotate(by: 4, modulus: 4)

		let expected = 0b00000110
		XCTAssertEqual(actual, expected)
	}

	func test_5_4 () {
		let actual = given.rotate(by: 5, modulus: 4)

		let expected = 0b00001100
		XCTAssertEqual(actual, expected)
	}

	func test_6_4 () {
		let actual = given.rotate(by: 6, modulus: 4)

		let expected = 0b00001001
		XCTAssertEqual(actual, expected)
	}

	func test_7_4 () {
		let actual = given.rotate(by: 7, modulus: 4)

		let expected = 0b00000011
		XCTAssertEqual(actual, expected)
	}

	func test_8_4 () {
		let actual = given.rotate(by: 8, modulus: 4)

		let expected = 0b00000110
		XCTAssertEqual(actual, expected)
	}
}

extension FixedWidthIntegerRotationTests {
	func test_minus1_6 () {
		let actual = given.rotate(by: -1, modulus: 6)

		let expected = 0b00010011
		XCTAssertEqual(actual, expected)
	}

	func test_minus2_6 () {
		let actual = given.rotate(by: -2, modulus: 6)

		let expected = 0b00101001
		XCTAssertEqual(actual, expected)
	}

	func test_minus1_4 () {
		let actual = given.rotate(by: -1, modulus: 4)

		let expected = 0b00000011
		XCTAssertEqual(actual, expected)
	}

	func test_minus2_4 () {
		let actual = given.rotate(by: -2, modulus: 4)

		let expected = 0b00001001
		XCTAssertEqual(actual, expected)
	}

	func test_minus3_4 () {
		let actual = given.rotate(by: -3, modulus: 4)

		let expected = 0b00001100
		XCTAssertEqual(actual, expected)
	}

	func test_minus4_4 () {
		let actual = given.rotate(by: -4, modulus: 4)

		let expected = 0b00000110
		XCTAssertEqual(actual, expected)
	}

	func test_minus5_4 () {
		let actual = given.rotate(by: -5, modulus: 4)

		let expected = 0b00000011
		XCTAssertEqual(actual, expected)
	}

	func test_minus6_4 () {
		let actual = given.rotate(by: -6, modulus: 4)

		let expected = 0b00001001
		XCTAssertEqual(actual, expected)
	}

	func test_minus7_4 () {
		let actual = given.rotate(by: -7, modulus: 4)

		let expected = 0b00001100
		XCTAssertEqual(actual, expected)
	}

	func test_minus8_4 () {
		let actual = given.rotate(by: -8, modulus: 4)

		let expected = 0b00000110
		XCTAssertEqual(actual, expected)
	}
}

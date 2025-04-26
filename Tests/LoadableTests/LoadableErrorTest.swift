import MultitoolTesting
import XCTest

@testable import Multitool

final class LoadableErrorTests: XCTestCase {
	func test_setResult_returningValue_shouldBeSuccessful () {
		// Given
		var loadable = Loadable.loading(value: "progress")

		// When
		loadable.setResult {
			"success"
		}
		// Then
		XCTAssertEqual(loadable, .successful("success"))
	}

	func test_setResult_throwingError_shouldBeFailed () {
		// Given
		var loadable = Loadable.loading(value: "progress")

		// When
		loadable.setResult {
			throw StubError.instance
		}
		// Then
		XCTAssertEqual(loadable, .failed(error: StubError.instance, value: "progress"))
	}

	func test_asyncSetResult_returningValue_shouldBeSuccessful () async {
		// Given
		var loadable = Loadable.loading(value: "progress")

		// When
		await loadable.setResult {
			try await Task.sleep(nanoseconds: 1)
			return "success"
		}
		// Then
		XCTAssertEqual(loadable, .successful("success"))
	}

	func test_asyncSetResult_throwingError_shouldBeFailed () async {
		// Given
		var loadable = Loadable.loading(value: "progress")

		// When
		await loadable.setResult {
			try await Task.sleep(nanoseconds: 1)
			throw StubError.instance
		}
		// Then
		XCTAssertEqual(loadable, .failed(error: StubError.instance, value: "progress"))
	}

	func test_result_returningValue_shouldBeSuccessful () {
		// Given
		let loadable = Loadable.loading(value: "progress")

		// When
		let result = loadable.perform {
			"success"
		}
		// Then
		XCTAssertEqual(result, .successful("success"))
	}

	func test_result_throwingError_shouldBeFailed () {
		// Given
		let loadable = Loadable.loading(value: "progress")

		// When
		let result = loadable.perform {
			throw StubError.instance
		}
		// Then
		XCTAssertEqual(result, .failed(error: StubError.instance, value: "progress"))
	}
}

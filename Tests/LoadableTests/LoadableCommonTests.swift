import MultitoolTesting
import XCTest

@testable import Multitool

final class LoadableCommonTests: XCTestCase {
	func test_debugName () {
		// Given
		var loadable = Loadable<Void>.initial

		// When
		loadable = .initial
		// Then
		XCTAssertEqual(loadable.debugName, "initial")

		// When
		loadable = .loading()
		// Then
		XCTAssertEqual(loadable.debugName, "loading")

		// When
		loadable = .successful(())
		// Then
		XCTAssertEqual(loadable.debugName, "successful")

		// When
		loadable = .failed(error: StubError.instance)
		// Then
		XCTAssertEqual(loadable.debugName, "failed")
	}

	func test_isCase () {
		// Given
		var loadable = Loadable<Void>.initial

		// When
		loadable = .initial
		// Then
		XCTAssertTrue(loadable.isInitial)
		XCTAssertFalse(loadable.isLoading)
		XCTAssertFalse(loadable.isSuccessful)
		XCTAssertFalse(loadable.isFailed)

		// When
		loadable = .loading()
		// Then
		XCTAssertFalse(loadable.isInitial)
		XCTAssertTrue(loadable.isLoading)
		XCTAssertFalse(loadable.isSuccessful)
		XCTAssertFalse(loadable.isFailed)

		// When
		loadable = .successful(())
		// Then
		XCTAssertFalse(loadable.isInitial)
		XCTAssertFalse(loadable.isLoading)
		XCTAssertTrue(loadable.isSuccessful)
		XCTAssertFalse(loadable.isFailed)

		// When
		loadable = .failed(error: StubError.instance)
		// Then
		XCTAssertFalse(loadable.isInitial)
		XCTAssertFalse(loadable.isLoading)
		XCTAssertFalse(loadable.isSuccessful)
		XCTAssertTrue(loadable.isFailed)
	}

	func test_value () {
		// Given
		var loadable = Loadable<String>.initial

		// When
		loadable = .initial
		// Then
		XCTAssertNil(loadable.value)
		XCTAssertNil(loadable.loadingValue)
		XCTAssertNil(loadable.successfulValue)
		XCTAssertNil(loadable.failedValue)

		// When
		loadable = .loading()
		// Then
		XCTAssertNil(loadable.value)
		XCTAssertNil(loadable.loadingValue)
		XCTAssertNil(loadable.successfulValue)
		XCTAssertNil(loadable.failedValue)

		// When
		loadable = .loading(previousValue: "progress")
		// Then
		XCTAssertEqual(loadable.value, "progress")
		XCTAssertEqual(loadable.loadingValue, "progress")
		XCTAssertNil(loadable.successfulValue)
		XCTAssertNil(loadable.failedValue)

		// When
		loadable = .successful("success")
		// Then
		XCTAssertEqual(loadable.value, "success")
		XCTAssertNil(loadable.loadingValue)
		XCTAssertEqual(loadable.successfulValue, "success")
		XCTAssertNil(loadable.failedValue)

		// When
		loadable = .failed(error: StubError.instance)
		// Then
		XCTAssertNil(loadable.value)
		XCTAssertNil(loadable.loadingValue)
		XCTAssertNil(loadable.successfulValue)
		XCTAssertNil(loadable.failedValue)

		// When
		loadable = .failed(error: StubError.instance, previousValue: "error")
		// Then
		XCTAssertEqual(loadable.value, "error")
		XCTAssertNil(loadable.loadingValue)
		XCTAssertNil(loadable.successfulValue)
		XCTAssertEqual(loadable.failedValue, "error")
	}

	func test_loadingTask () {
		// Given
		var loadable = Loadable<String>.initial
		let task = VoidTask { }

		// When
		loadable = .loading(task: task)
		// Then
		XCTAssertEqual(loadable.loadingTask, task)

		// When
		loadable = .initial
		// Then
		XCTAssertNil(loadable.loadingTask)
	}

	func test_error () {
		// Given
		var loadable = Loadable<String>.initial
		let error = StubError.instance

		// When
		loadable = .failed(error: error)
		// Then
		XCTAssertNotNil(loadable.error)

		// When
		loadable = .initial
		// Then
		XCTAssertNil(loadable.error)
	}
}

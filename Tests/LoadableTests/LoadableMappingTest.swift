import MultitoolTesting
import XCTest

@testable import Multitool

final class LoadableMappingTesst: XCTestCase {
	func test_setIfInitial_success () {
		// Given
		var loadable = Loadable<String>.initial()

		// When
		loadable.setIfInitial(.successful("initial"))

		// Then
		XCTAssertEqual(loadable, .successful("initial"))
	}

	func test_setIfInitial_failure () {
		// Given
		var loadable = Loadable<String>.initial()

		// When
		loadable.setIfSuccessful(.successful("initial"))

		// Then
		XCTAssertEqual(loadable, .initial())
	}

	func test_setIfSuccessful_success () {
		// Given
		var loadable = Loadable<String>.successful("initial")

		// When
		loadable.setIfSuccessful(.initial())

		// Then
		XCTAssertEqual(loadable, .initial())
	}

	func test_setIfSuccessful_failure () {
		// Given
		var loadable = Loadable<String>.successful("initial")

		// When
		loadable.setIfInitial(.initial())

		// Then
		XCTAssertEqual(loadable, .successful("initial"))
	}

	func test_setIfLoading_success () {
		// Given
		let task = LoadingTask { }
		var loadable = Loadable<String>.loading(task: task)

		// When
		loadable.setIfLoading(.initial())

		// Then
		XCTAssertEqual(loadable, .initial())
		XCTAssertTrue(task.isCancelled)
	}

	func test_setIfLoading_failure () {
		// Given
		let task = LoadingTask { }
		var loadable = Loadable<String>.loading(task: task)

		// When
		loadable.setIfInitial(.successful("initial"))

		// Then
		XCTAssertEqual(loadable, .processing(.init(previousValue: nil, task: task)))
		XCTAssertFalse(task.isCancelled)
	}

	func test_setIfFailed_success () {
		// Given
		var loadable = Loadable<String>.failed(StubError.instance)

		// When
		loadable.setIfFailed(.initial())

		// Then
		XCTAssertEqual(loadable, .initial())
	}

	func test_setIfFailed_failure () {
		// Given
		var loadable = Loadable<String>.failed(StubError.instance)

		// When
		loadable.setIfInitial(.initial())

		// Then
		XCTAssertEqual(loadable, .failed(StubError.instance))
	}
}

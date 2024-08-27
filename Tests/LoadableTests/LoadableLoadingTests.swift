import XCTest

@testable import Multitool

final class LoadableLoadingTests: XCTestCase {
	func test_loading_newvalue_shouldContainsNewValueAndOldTask () {
		// Given
		let task = VoidTask { }
		let loadable = Loadable.loading(task: task, value: "progress")

		// When
		let newLoadable = loadable.loading(value: "new progress")

		// Then
		XCTAssertEqual(newLoadable, .loading(task: task, value: "new progress"))
	}

	func test_loading_newTask_shouldContainsNewTaskAndOldValue () {
		// Given
		let task = VoidTask { }
		let loadable = Loadable.loading(task: task, value: "progress")

		// When
		let newLoadable = loadable.loading(task: task)

		// Then
		XCTAssertEqual(newLoadable, .loading(task: task, value: "progress"))
	}

	func test_loading_newTaskWithAction_shouldContainsNewTaskAndOldValue () {
		// Given
		let task = VoidTask { }
		let loadable = Loadable.loading(task: task, value: "progress")

		// When
		let newLoadable = loadable.loading { task }

		// Then
		XCTAssertEqual(newLoadable, .loading(task: task, value: "progress"))
	}

	func test_staticLoading_newvalue_shouldContainsOldValue () {
		// When
		let newLoadable = Loadable.loading(value: "new progress")

		// Then
		XCTAssertEqual(newLoadable, .loading(task: nil, value: "new progress"))
	}

	func test_staticLoading_newTask_shouldContainsNewTask () {
		// Given
		let task = VoidTask { }

		// When
		let newLoadable = Loadable<String>.loading(task: task)

		// Then
		XCTAssertEqual(newLoadable, .loading(task: task, value: nil))
	}

	func test_staticLoading_newTaskWithActionAndvalue_shouldContainsNewTask () {
		// Given
		let task = VoidTask { }

		// When
		let newLoadable = Loadable<String>.loading(value: "progress") { task }

		// Then
		XCTAssertEqual(newLoadable, .loading(task: task, value: "progress"))
	}

	func test_loading_withoutParams_shouldBeEqualToLoading () {
		// Given
		let loadable = Loadable.successful("successful")

		// When
		let newLoadable = loadable.loading()
		
		// Then
		XCTAssertEqual(newLoadable, .loading(task: nil, value: "successful"))
	}

	func test_loading_withPreviousLoading_shouldBeEqualToLoading () {
		// Given
		let task = VoidTask { }
		let loadable = Loadable.loading(task: task, value: "progress")

		// When
		let newLoadable = loadable.loading()

		// Then
		XCTAssertEqual(newLoadable, .loading(task: task, value: "progress"))
	}

	func test_staticLoading_withoutParams_shouldBeEqualToLoading () {
		// When
		let newLoadable = Loadable<String>.loading()

		// Then
		XCTAssertEqual(newLoadable, .loading(task: nil, value: nil))
	}
}

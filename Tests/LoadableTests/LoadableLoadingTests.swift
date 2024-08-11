import XCTest

@testable import Multitool

final class LoadableLoadingTests: XCTestCase {
	func test_loading_newPreviousValue_shouldContainsNewValueAndOldTask () {
		// Given
		let task = VoidTask { }
		let loadable = Loadable.loading(task: task, previousValue: "progress")

		// When
		let newLoadable = loadable.loading(previousValue: "new progress")

		// Then
		XCTAssertEqual(newLoadable, .loading(task: task, previousValue: "new progress"))
	}

	func test_loading_newTask_shouldContainsNewTaskAndOldValue () {
		// Given
		let task = VoidTask { }
		let loadable = Loadable.loading(task: task, previousValue: "progress")

		// When
		let newLoadable = loadable.loading(task: task)

		// Then
		XCTAssertEqual(newLoadable, .loading(task: task, previousValue: "progress"))
	}

	func test_loading_newTaskWithAction_shouldContainsNewTaskAndOldValue () {
		// Given
		let task = VoidTask { }
		let loadable = Loadable.loading(task: task, previousValue: "progress")

		// When
		let newLoadable = loadable.loading { task }

		// Then
		XCTAssertEqual(newLoadable, .loading(task: task, previousValue: "progress"))
	}

	func test_staticLoading_newPreviousValue_shouldContainsOldValue () {
		// When
		let newLoadable = Loadable.loading(previousValue: "new progress")

		// Then
		XCTAssertEqual(newLoadable, .loading(task: nil, previousValue: "new progress"))
	}

	func test_staticLoading_newTask_shouldContainsNewTask () {
		// Given
		let task = VoidTask { }

		// When
		let newLoadable = Loadable<String>.loading(task: task)

		// Then
		XCTAssertEqual(newLoadable, .loading(task: task, previousValue: nil))
	}

	func test_staticLoading_newTaskWithActionAndPreviousValue_shouldContainsNewTask () {
		// Given
		let task = VoidTask { }

		// When
		let newLoadable = Loadable<String>.loading(previousValue: "progress") { task }

		// Then
		XCTAssertEqual(newLoadable, .loading(task: task, previousValue: "progress"))
	}

	func test_loading_withoutParams_shouldBeEqualToLoading () {
		// Given
		let loadable = Loadable.successful("successful")

		// When
		let newLoadable = loadable.loading()
		
		// Then
		XCTAssertEqual(newLoadable, .loading(task: nil, previousValue: "successful"))
	}

	func test_loading_withPreviousLoading_shouldBeEqualToLoading () {
		// Given
		let task = VoidTask { }
		let loadable = Loadable.loading(task: task, previousValue: "progress")

		// When
		let newLoadable = loadable.loading()

		// Then
		XCTAssertEqual(newLoadable, .loading(task: task, previousValue: "progress"))
	}

	func test_staticLoading_withoutParams_shouldBeEqualToLoading () {
		// When
		let newLoadable = Loadable<String>.loading()

		// Then
		XCTAssertEqual(newLoadable, .loading(task: nil, previousValue: nil))
	}
}

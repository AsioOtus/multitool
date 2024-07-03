import XCTest

@testable import Multitool

final class LoadableTests: XCTestCase {
	func test_loadableCancellation () async throws {
		// Given
		let task = LoadingTask { }

		// When
		let loadable = Loadable<String>.loading(task: task)

		// Then
		XCTAssertEqual(loadable, .processing(.init(previousValue: nil, task: task)))
		XCTAssertFalse(task.isCancelled)

		// When
		loadable.cancel()

		// Then
		XCTAssertEqual(loadable, .processing(.init(previousValue: nil, task: task)))
		XCTAssertTrue(task.isCancelled)
	}

	func test_setLoading () async throws {
		// Given
		let task = LoadingTask { }
		var loadable = Loadable<String>.initial()

		// When
		loadable.setLoading(task: task)

		// Then
		await loadable.loadingValue?.task?.wait()

		XCTAssertEqual(loadable, .loading(task: task))
	}

	func test_setLoadingAction () async throws {
		// Given
		let initialValue = "initial"

		let initialTask = LoadingTask { }
		let overwritingTask = LoadingTask { }

		var loadable = Loadable<String>.successful(initialValue)

		// When
		loadable.setLoading(task: initialTask)

		// Then
		XCTAssertFalse(initialTask.isCancelled)

		// When
		loadable.setLoading(task: overwritingTask)

		// Then
		await initialTask.wait()
		await loadable.loadingValue?.task?.wait()

		XCTAssertTrue(initialTask.isCancelled)
		XCTAssertEqual(loadable.loadingValue?.previousValue, initialValue)
	}

	func test_loading () async {
		// Given
		let initialValue = "initial"
		let initialTask = LoadingTask { }
		let loadable = Loadable.loading(previousValue: initialValue, task: initialTask)

		// When
		let newLoadable = loadable.loading()

		// Then
		XCTAssertEqual(newLoadable.loadingValue, .init(previousValue: initialValue, task: initialTask))
	}

	func test_loadingWithNewTask () async {
		// Given
		let initialValue = "initial"
		let initialTask = LoadingTask { }
		let overwritingTask = LoadingTask { }
		let loadable = Loadable.loading(previousValue: initialValue, task: initialTask)

		// When
		let newLoadable = loadable.loading(task: overwritingTask)

		// Then
		XCTAssertEqual(loadable.loadingValue, .init(previousValue: initialValue, task: initialTask))
		XCTAssertEqual(newLoadable.loadingValue, .init(previousValue: initialValue, task: overwritingTask))
		XCTAssertFalse(initialTask.isCancelled)
	}

	func test_loadingCancellationWithNewTask () async {
		// Given
		let initialValue = "initial"
		let initialTask = LoadingTask { }
		let overwritingTask = LoadingTask { }
		let loadable = Loadable.loading(previousValue: initialValue, task: initialTask)

		// When
		let newLoadable = loadable.cancel().loading(task: overwritingTask)

		// Then
		XCTAssertEqual(loadable.loadingValue, .init(previousValue: initialValue, task: initialTask))
		XCTAssertEqual(newLoadable.loadingValue, .init(previousValue: initialValue, task: overwritingTask))
		XCTAssertTrue(initialTask.isCancelled)
	}
}

import XCTest
@testable import Multitool

final class TreeTests: XCTestCase {
	func test_treeDepth () {
		// Given
		let tree: Tree = .init(
			value: "1.",
			nodes: [
				.init(value: "1.1."),
				.init(
					value: "1.2.",
					nodes: [
						.init(value: "1.2.1."),
						.init(value: "1.2.2."),
					]
				),
				.init(value: "1.3."),
			]
		)

		// When
		let depth = tree.depth

		// Then
		XCTAssertEqual(depth, 3)
	}

	func test_isLeaf () {
		// Given
		let tree = Tree(value: "1.")

		// When
		let isLeaf = tree.isLeaf

		// Then
		XCTAssertTrue(isLeaf)
	}

	func test_isNode () {
		// Given
		let tree = Tree(
			value: "1.",
			nodes: [
				.init(value: "1.1."),
			]
		)

		// When
		let isNode = tree.isNode

		// Then
		XCTAssertTrue(isNode)
	}
}

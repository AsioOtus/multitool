//import XCTest
//@testable import Multitool
//
//class WhateverTests: XCTestCase {
//	func testStandard () {
//		let validation = AnyProcessor<String, String>
//			.whatever([
//				.process { .success($0 + "456") },
//				.process { .success($0 + "789") },
//				.failure(),
//				.process(label: "A") { .success($0 + "000") }
//			])
//		
//		let validationResult = validation.process("123")
//		print(validationResult.description)
//	}
//}

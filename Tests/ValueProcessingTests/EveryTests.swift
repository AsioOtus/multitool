import XCTest
@testable import Multitool

class EveryTests: XCTestCase {
	func testEmpty () {
		let validation = AnyProcessor<String, String>
			.every([ ])
		
		let validationResult = validation.process("123")
		print(validationResult.description)
	}
	
	func testStandard () {
		let validation = AnyProcessor<String, String>
			.every([
				.process { .success($0 + "456") },
				.process { .success($0 + "789") },
				.failure()
			])
		
		let validationResult = validation.process("123")
		print(validationResult.description)
	}
	
	func testAllFailures () {
		let validation = AnyProcessor<String, String>
			.every([
				.failure(),
				.failure()
			])
		
		let validationResult = validation.process("123")
		print(validationResult.description)
	}
}

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
		let validation = AnyProcessor<String, String?>
			.every([
				.process(failure: nil) { $0 + "123" }
			])
		
		let validationResult = validation.process("123")
		print(validationResult.description)
	}
	
	func testAllFailures () {
		let validation = AnyProcessor<String, String?>
			.every([
				.failure(nil),
				.failure(nil)
			])
		
		let validationResult = validation.process("123")
		print(validationResult.description)
	}
}

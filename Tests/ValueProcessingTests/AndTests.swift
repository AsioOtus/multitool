import XCTest
@testable import ValueProcessing

class AndTests: XCTestCase {
	func testEmpty () {
		let validation = AnyProcessor<String, String>
			.and([ ])
		
		let validationResult = validation.process("123")
		print(validationResult.description)
	}
}

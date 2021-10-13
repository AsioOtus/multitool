import XCTest
@testable import MultitoolBase

class ProcessingTests: XCTestCase {
	func test () {
		let passwordValidation: AnyProcessor<String, String> =
			.and([
				.validate(label: "Random validation") { _ in .success },
				.longerThan(8),
			])
		
		let result = passwordValidation.process("qwe112313rty")
		print(result.description)
	}
	
	func test2 () {
		let validation = AnyProcessor<String, String>
			.whatever([
				.failure(label: "A"),
				.failure(label: "B"),
				.success(label: "A"),
				.success(label: "B"),
				.failure(label: "C"),
				.failure(label: "D"),
				.success(label: "C"),
				.success(label: "D"),
			])
			
		let validationResult = validation.process("123")
		print(validationResult.description)
	}
}

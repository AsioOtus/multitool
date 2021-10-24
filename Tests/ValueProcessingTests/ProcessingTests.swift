import XCTest
@testable import ValueProcessing

class ProcessingTests: XCTestCase {
	func test () {
		struct Person {
			let name: String
			let surname: String
			
			let age: Int
		}
		
		let person = Person(name: "Alexander", surname: "Nevsky", age: 41)
		
		let ageValidationResult = AnyProcessor<Int, String>
			.and([
				.validate(failure: "") { $0 >= 18 }
			])
			.process(person.age)
		
		let nameValidationResult = And<String, String>([
			.validate(failure: "") { $0.count >= 18 }
		])
		.process(person.name)
		
		AnyProcessor<Person, String>
			.and([
				.validate(failure: "") {
					And([
						.validate(failure: "") { $0.count >= 18 }
					])
					.process($0.name)
					.summary.isSuccess
				},
			])
		
		AnyProcessor<Void, String>
			.and([
				.validate(failure: "") { ageValidationResult.summary.isSuccess },
				.validate(failure: "") { nameValidationResult.summary.isSuccess }
			])
			.process()
		
		print(ageValidationResult.description)
		print(nameValidationResult.description)
	}
}

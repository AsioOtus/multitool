import XCTest
@testable import MultitoolBase
import Foundation

class ParsingTests: XCTestCase {
	func testDefaultCase () {
		struct QRCodeValueParsingModel {
			var userId: String = ""
			var ticketId: String = ""
			var typeId: String = ""
			var purchaseTime: String = ""
			var regTime: String = ""
			var ticketSignature: String = ""
			var vehicleNr: String = ""
			var userSignature: String = ""
		}
		
		
		let scheme = "rsctl://"
		let parsing = Parsing<ParsingContainer<String, QRCodeValueParsingModel>, String>
			.and([
				.rule({ ($0.original.starts(with: scheme), $0) }, "Invalid scheme"),
				.rule({
					var container = $0
					container.current.removeFirst(scheme.count)
					return (true, container)
				}),
				.rule({
					var container = $0
					let components = container.current.split(separator: "/").map(String.init)
					
					let isEnoughComponents = components.count >= 5
					
					if isEnoughComponents {
						container.result.userId = components[0]
						container.result.ticketId = components[1]
						container.result.typeId = components[2]
						container.result.purchaseTime = components[3]
						container.result.regTime = components[4]
					}
					
					container.current = components[5...].joined(separator: "/")
					
					return (isEnoughComponents, container)
				}, "Not enough components"),
				.rule({ ($0.current.count >= 88, $0) }, "Too small ticket signature length"),
				.rule({
					var container = $0
					let ticketSignature = container.current[...container.current.index(container.current.startIndex, offsetBy: 88)]
					container.current.removeFirst(88)
					container.result.ticketSignature = String(ticketSignature)
					return (true, container)
				}),
				.rule({ ($0.current.count >= 6, $0) }, "Too small vehicle number length"),
				.rule({
					var container = $0
					container.current.removeFirst()
					let ticketSignature = container.current[...container.current.index(container.current.startIndex, offsetBy: 4)]
					container.current.removeFirst(4)
					container.result.vehicleNr = String(ticketSignature)
					return (true, container)
				}),
				.rule({ ($0.current.count >= 88, $0) }, "Too small user signature length"),
				.rule({
					var container = $0
					container.current.removeFirst()
					let ticketSignature = container.current[...container.current.index(container.current.startIndex, offsetBy: 88)]
					container.current.removeFirst(88)
					container.result.userSignature = String(ticketSignature)
					return (true, container)
				}),
			])
		
		
		
		
		
		let qrCodeValue = "rsctl://4102cab2-ad2c-44c5-84da-e281a499d393/e1700786-01f7-4b28-9632-17c2bbc8abc5/caa5942b-f02b-4b09-a9f1-4add36748b2d/1619436148/1619436181/Af+0wJnF48Ucd9RG5k7XJUJ7K40J0kTdP7fvooDpRSNhPQ88M+poZcJzC73/fJGYlmzbXEMPT0Cf6POveiWkDw==/16077/Af+0wJnF48Ucd9RG5k7XJUJ7K40J0kTdP7fvooDpRSNhPQ88M+poZcJzC73/fJGYlmzbXEMPT0Cf6POveiWkDw=="
		let parsingResult = parsing
			.parse(ParsingContainer(original: qrCodeValue, result: QRCodeValueParsingModel()))
		
		print(parsingResult)

	}
}

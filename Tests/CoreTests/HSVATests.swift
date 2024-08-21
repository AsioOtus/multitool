import XCTest

@testable import Multitool

final class HSVATests: XCTestCase {
	func test () {
		// Given
		let hsv: [HSVA] = [
			.init(h: 0,         s: 0, v: 0),
			.init(h: 0,         s: 0, v: 1),
			.init(h: 0,         s: 1, v: 1),
			.init(h: 120 / 360, s: 1, v: 1),
			.init(h: 240 / 360, s: 1, v: 1),
			.init(h: 60  / 360, s: 1, v: 1),
			.init(h: 180 / 360, s: 1, v: 1),
			.init(h: 300 / 360, s: 1, v: 1),

			.init(h: 0,         s: 0, v: 0.75),
			.init(h: 0,         s: 0, v: 0.5),
			.init(h: 0,         s: 1, v: 0.5),
			.init(h: 60  / 360, s: 1, v: 0.5),
			.init(h: 120 / 360, s: 1, v: 0.5),
			.init(h: 300 / 360, s: 1, v: 0.5),
			.init(h: 180 / 360, s: 1, v: 0.5),
			.init(h: 240 / 360, s: 1, v: 0.5),
		]

		// When
		let resultRgb = hsv.map(\.rgba)
		print(resultRgb.map(\.rawDescription))

		// Then
		let expectedRgb: [RGBA] = [
			.init(r: 0, g: 0, b: 0),
			.init(r: 1, g: 1, b: 1),
			.init(r: 1, g: 0, b: 0),
			.init(r: 0, g: 1, b: 0),
			.init(r: 0, g: 0, b: 1),
			.init(r: 1, g: 1, b: 0),
			.init(r: 0, g: 1, b: 1),
			.init(r: 1, g: 0, b: 1),

			.init(r: 0.75, g: 0.75, b: 0.75),
			.init(r: 0.5,  g: 0.5, b: 0.5),
			.init(r: 0.5,  g: 0,   b: 0),
			.init(r: 0.5,  g: 0.5, b: 0),
			.init(r: 0,    g: 0.5, b: 0),
			.init(r: 0.5,  g: 0,   b: 0.5),
			.init(r: 0,    g: 0.5, b: 0.5),
			.init(r: 0,    g: 0,   b: 0.5),
		]

		XCTAssertEqual(resultRgb, expectedRgb)
	}
}

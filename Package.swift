// swift-tools-version:5.5

import PackageDescription

let package = Package(
	name: "Multitool",
	products: [
		.library(
			name: "Multitool",
			targets: ["Multitool"]
		)
	],
	targets: [
		.target(
			name: "Multitool",
      path: "Sources/Core"
		),
		.target(
			name: "Drafts"
		),
		
		.executableTarget(
			name: "CoreTestground",
			dependencies: ["Multitool"]
		),
		.executableTarget(
			name: "DraftsTestground",
			dependencies: ["Drafts"]
		),
		
		.testTarget(
			name: "CoreTests",
			dependencies: ["Multitool"]
		)
	]
)

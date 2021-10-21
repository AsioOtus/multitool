// swift-tools-version:5.5

import PackageDescription

let package = Package(
	name: "Multitool",
	products: [
		.library(
			name: "Multitool",
			targets: ["Multitool"]
		),
	],
	targets: [
		.target(
			name: "Multitool",
			path: "Sources/Core"
		),
		.target(
			name: "Drafts",
			path: "Sources/Drafts"
		),
		
		.executableTarget(
			name: "MultitoolTestground",
			dependencies: ["Multitool"]
		),
		.executableTarget(
			name: "DraftsTestground",
			dependencies: ["Drafts"]
		),
		
		.testTarget(
			name: "CoreTests",
			dependencies: ["Multitool"]
		),
		.testTarget(
			name: "DispatchTests",
			dependencies: ["Multitool"]
		),
		.testTarget(
			name: "ValueProcessingTests",
			dependencies: ["Multitool"]
		),
	]
)

// swift-tools-version:5.5

import PackageDescription

let package = Package(
	name: "Multitool",
	products: [
		.library(
			name: "Multitool",
			targets: ["Core"]
		)
	],
	targets: [
		.target(
			name: "Core"
		),
		.target(
			name: "Drafts"
		),
		
		.executableTarget(
			name: "CoreTestground",
			dependencies: ["Core"]
		),
		.executableTarget(
			name: "DraftsTestground",
			dependencies: ["Drafts"]
		),
		
		.testTarget(
			name: "CoreTests",
			dependencies: ["Core"]
		)
	]
)

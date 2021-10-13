// swift-tools-version:5.5

import PackageDescription

let package = Package(
	name: "Multitool",
	products: [
		.library(
			name: "Multitool",
			targets: ["Multitool"]),
	],
	dependencies: [],
	targets: [
		.target(
			name: "Multitool",
			path: "Sources/Core"),
		.executableTarget(
			name: "MultitoolTestground",
			dependencies: ["Multitool"]),
		.testTarget(
			name: "CoreTests",
			dependencies: ["Multitool"]),
		.testTarget(
			name: "DispatchTests",
			dependencies: ["Multitool"]),
		.testTarget(
			name: "ValueProcessingTests",
			dependencies: ["Multitool"]),
	]
)

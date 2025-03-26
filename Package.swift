// swift-tools-version:6.0

import PackageDescription

let package = Package(
	name: "multitool",
  platforms: [
    .iOS(.v15),
    .macOS(.v12),
  ],
	products: [
		.library(
			name: "Multitool",
			targets: ["Multitool"]
		),
		.library(
			name: "MultitoolTesting",
			targets: ["MultitoolTesting"]
		),
	],
	targets: [
		.target(
			name: "Multitool",
            path: "Sources/Core"
		),
		.target(
			name: "MultitoolTesting",
			path: "Sources/Testing"
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
			dependencies: [
				"Multitool",
				"MultitoolTesting"
			]
		),
		.testTarget(
			name: "LoadableTests",
			dependencies: [
				"Multitool",
				"MultitoolTesting"
			]
		),
	]
)

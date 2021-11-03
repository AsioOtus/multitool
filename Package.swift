// swift-tools-version:5.5

import PackageDescription

let package = Package(
	name: "Multitool",
	products: [
		.library(
			name: "Multitool",
			targets: ["Multitool", "MultitoolStringConverters"]
		),
		.library(
			name: "MultitoolDispatch",
			targets: ["MultitoolDispatch"]
		),
		.library(
			name: "MultitoolValueProcessing",
			targets: ["MultitoolValueProcessing"]
		),
	],
	targets: [
		.target(
			name: "Multitool",
			path: "Sources/Core/Common"
		),
		.target(
			name: "MultitoolDispatch",
			path: "Sources/Core/Specified/Dispatch"
		),
		.target(
			name: "MultitoolStringConverters",
			path: "Sources/Core/Specified/StringConverters"
		),
		.target(
			name: "MultitoolValueProcessing",
			path: "Sources/Core/Specified/ValueProcessing"
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
			dependencies: ["MultitoolDispatch"]
		),
		.testTarget(
			name: "ValueProcessingTests",
			dependencies: ["MultitoolValueProcessing"]
		),
	]
)

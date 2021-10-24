// swift-tools-version:5.5

import PackageDescription

let package = Package(
	name: "Multitool",
	products: [
		.library(
			name: "Multitool",
			targets: ["Multitool", "StringConverters"]
		),
		.library(
			name: "MultitoolDispatch",
			targets: ["DispatchClasses"]
		),
		.library(
			name: "MultitoolValueProcessing",
			targets: ["ValueProcessing"]
		),
	],
	targets: [
		.target(
			name: "Multitool",
			path: "Sources/Core/Common"
		),
		.target(
			name: "DispatchClasses",
			path: "Sources/Core/Specified/Dispatch"
		),
		.target(
			name: "StringConverters",
			path: "Sources/Core/Specified/StringConverters"
		),
		.target(
			name: "ValueProcessing",
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
			dependencies: ["Multitool"]
		),
		.testTarget(
			name: "ValueProcessingTests",
			dependencies: ["ValueProcessing"]
		),
	]
)

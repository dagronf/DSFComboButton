// swift-tools-version:5.3

import PackageDescription

let package = Package(
	name: "DSFComboButton",
	platforms: [
		.macOS(.v10_13)
	],
	products: [
		.library(name: "DSFComboButton", targets: ["DSFComboButton"]),
		.library(name: "DSFComboButton-static", type: .static, targets: ["DSFComboButton"]),
		.library(name: "DSFComboButton-shared", type: .dynamic, targets: ["DSFComboButton"]),
	],
	targets: [
		.target(
			name: "DSFComboButton",
			dependencies: []),
		.testTarget(
			name: "DSFComboButtonTests",
			dependencies: ["DSFComboButton"]),
	]
)

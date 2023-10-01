// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "FloatingBottomSheet",
  platforms: [.iOS(.v14)],
  products: [
    .library(
      name: "FloatingBottomSheet",
      targets: ["FloatingBottomSheet"]
    ),
  ],
  targets: [
    .target(
      name: "FloatingBottomSheet"
    ),
    .testTarget(
      name: "FloatingBottomSheetTests",
      dependencies: ["FloatingBottomSheet"]
    ),
  ]
)

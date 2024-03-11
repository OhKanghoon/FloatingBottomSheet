// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "FloatingBottomSheet",
  platforms: [.iOS(.v11)],
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

#if swift(>=5.6)
package.dependencies.append(
  .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.3.0")
)
#endif
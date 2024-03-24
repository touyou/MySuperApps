// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SuperAppLib",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v14), .watchOS(.v10), .tvOS(.v17), .visionOS(.v1)],
    products: [
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]),
        .library(
            name: "SharedModels",
            targets: ["SharedModels"]),
    ],
    dependencies: [
      .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.9.1"),
      .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.2.0"),
      .package(url: "https://github.com/zunda-pixel/LicenseProvider", from: "1.1.1"),
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                "SharedModels"
            ]
        ),
        .target(
            name: "SharedModels"),
        .target(
            name: "SwiftDataClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "AppFeatureTests",
            dependencies: ["AppFeature"]
        ),
    ]
)

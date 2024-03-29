// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ViewStateController",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "ViewStateController",
            targets: ["ViewStateController"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ViewStateController",
            dependencies: [],
            path: "Sources",
            exclude: [".swiftformat"]
        ),
        .testTarget(
            name: "ViewStateControllerTests",
            dependencies: ["ViewStateController"]
        )
    ]
)

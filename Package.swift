// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ViewStateController",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
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
            exclude: ["ControllerExampleApp/"]
        ),
        .testTarget(
            name: "ViewStateControllerTests",
            dependencies: ["ViewStateController"]
        )
    ]
)

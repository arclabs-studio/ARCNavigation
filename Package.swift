// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ARCNavigation",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v7)
    ],
    products: [
        .library(
            name: "ARCNavigation",
            targets: ["ARCNavigation"]
        ),
    ],
    targets: [
        .target(
            name: "ARCNavigation",
            path: "Sources"
        ),
        .testTarget(
            name: "ARCNavigationTests",
            dependencies: ["ARCNavigation"],
            path: "Tests"
        )
    ]
)

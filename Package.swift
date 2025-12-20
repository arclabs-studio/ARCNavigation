// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ARCNavigation",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10)
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
            path: "Sources/ARCNavigation",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "ARCNavigationTests",
            dependencies: ["ARCNavigation"],
            path: "Tests/ARCNavigationTests",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        )
    ]
)

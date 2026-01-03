// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ARCNavigation",

    // MARK: - Platforms

    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10)
    ],

    // MARK: - Products
    // Only export the main library - Demo is NOT included

    products: [
        .library(
            name: "ARCNavigation",
            targets: ["ARCNavigation"]
        )
        // Note: Demo app is a standalone Xcode project in Example/ folder
    ],

    // MARK: - Targets

    targets: [
        // Main library
        .target(
            name: "ARCNavigation",
            path: "Sources/ARCNavigation",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),

        // Tests
        .testTarget(
            name: "ARCNavigationTests",
            dependencies: ["ARCNavigation"],
            path: "Tests/ARCNavigationTests"
        )
        // Note: Demo apps are standalone Xcode projects in Example/ folder
        // NOT executable targets in Package.swift
    ],

    // MARK: - Swift Language

    swiftLanguageModes: [.v6]
)

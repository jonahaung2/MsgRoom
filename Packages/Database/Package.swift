// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
let package = Package(
    name: "Database",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Database",
            targets: ["Database"]),
    ],
    dependencies: [
        .package(name: "Models", path: "../Models")
    ],
    targets: [
        .target(
            name: "Database",
            dependencies: [
                .product(name: "Models", package: "Models"),
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
            ]
        ),
        .testTarget(
            name: "DatabaseTests",
            dependencies: ["Database"]),
    ]
)

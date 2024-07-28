// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Services",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Services",
            targets: ["Services"]),
    ],
    dependencies: [
        .package(name: "Database", path: "../Database")
    ],
    targets: [
        .target(
            name: "Services",
            dependencies: [
                .product(name: "Database", package: "Database")
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
            ]
        ),
        .testTarget(
            name: "ServicesTests",
            dependencies: ["Services"]),
    ]
)

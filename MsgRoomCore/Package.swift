// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MsgRoomCore",
    platforms: [.iOS(.v17), .macOS(.v14), .tvOS(.v17)],
    products: [
        .library(
            name: "MsgRoomCore",
            targets: ["MsgRoomCore"]),
    ],
    dependencies: [
        .package(path: "../../Packages/XUI"),
    ],
    targets: [
        .target(
            name: "MsgRoomCore",
            dependencies: [
                .init(stringLiteral: "XUI")
            ]
        ),
        
        .testTarget(
            name: "MsgRoomCoreTests",
            dependencies: ["MsgRoomCore"]),
    ]
)

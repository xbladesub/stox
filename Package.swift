// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "stox",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-tools-support-core.git",
                 from: "0.0.1"),
        .package(url: "https://github.com/apple/swift-argument-parser",
                 from: "0.0.1")
    ],
    targets: [
        .executableTarget(name: "stox", dependencies: ["StoxCore"]),
        .target(name: "StoxCore", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            .product(name: "SwiftToolsSupport", package: "swift-tools-support-core")
        ]),
        .testTarget(
            name: "stoxTests",
            dependencies: ["stox"])
    ]
)

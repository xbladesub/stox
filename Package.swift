// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "stox",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-tools-support-core.git", from: "0.0.1"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1"),
        .package(name: "Reachability", url: "https://github.com/ashleymills/Reachability.swift",
                 .upToNextMajor(from: "5.1.0"))
    ],
    targets: [
        .executableTarget(name: "stox", dependencies: ["StoxCore"]),
        .target(name: "StoxCore", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            .product(name: "SwiftToolsSupport-auto", package: "swift-tools-support-core"),
            .product(name: "Reachability", package: "Reachability")
        ]),
        .testTarget(
            name: "stoxTests",
            dependencies: ["stox"])
    ]
)

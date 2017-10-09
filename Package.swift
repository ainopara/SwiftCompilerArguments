// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "SwiftCompilerArguments",
    products: [
        .library(
            name: "SwiftCompilerArguments",
            targets: ["SwiftCompilerArguments"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftCompilerArguments",
            dependencies: []),
        .testTarget(
            name: "SwiftCompilerArgumentsTests",
            dependencies: ["SwiftCompilerArguments"]),
    ]
)

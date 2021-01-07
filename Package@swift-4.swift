// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Once",
    products: [
        .library(
            name: "Once",
            targets: ["OnceC", "Once"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "OnceC",
            dependencies: [],
            path: "Sources/OnceC"
        ),
        .target(
            name: "Once",
            dependencies: ["OnceC"],
            path: "Sources/Swift"
        ),
        .testTarget(
            name: "OnceTests",
            dependencies: ["Once"]
        ),
    ]
)

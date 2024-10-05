// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Once",
    products: [
        .library(
            name: "Once",
            targets: ["Once"]
        ),
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
            dependencies: [
                .target(name: "OnceC")
            ],
            path: "Sources/Swift"
        ),
        .testTarget(
            name: "OnceTests",
            dependencies: [
                .target(name: "Once")
            ]
        ),
    ]
)

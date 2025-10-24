// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PresentationLayer",
    platforms: [
        .iOS(.v26),
        .macOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PresentationLayer",
            targets: ["PresentationLayer"]
        ),
    ],
    dependencies: [
        .package(path: "../DataLayer"), // Consumed only by testing for integration/end-to-end
        .package(path: "../DomainLayer")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PresentationLayer",
            dependencies: ["DomainLayer"]
        ),
        .testTarget(
            name: "PresentationLayerTests",
            dependencies: ["DataLayer", // Consumed only by testing for integration/end-to-end,
                           "PresentationLayer"]
        ),
    ]
)

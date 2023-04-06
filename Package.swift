// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "NovaCore",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        .library(name: "NovaCore", targets: ["NovaCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-numerics", branch: "main"),
    ],
    targets: [
        .target(
            name: "NovaCore",
            dependencies: [.product(name: "Numerics", package: "swift-numerics")],
            path: "Sources/"),
        .testTarget(name: "NovaCoreTests", dependencies: ["NovaCore"], path: "Tests/"),
    ]
)

// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "NovaCore",
    products: [
        .library(
            name: "NovaCore",
            targets: ["NovaCore"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "NovaCore",
            dependencies: [],
            path: "Sources/"),
        .testTarget(
            name: "NovaCoreTests",
            dependencies: ["NovaCore"]),
    ]
)

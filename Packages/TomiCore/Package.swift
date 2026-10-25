// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "TomiCore",
    platforms: [.iOS("27.0"), .macOS("26.0")],
    products: [
        .library(name: "TomiCore", targets: ["TomiCore"])
    ],
    targets: [
        .target(name: "TomiCore"),
        .testTarget(
            name: "TomiCoreTests",
            dependencies: ["TomiCore"],
            resources: [.copy("Server/Suggestions/Teaching/teaching-suggestion.json")]
        ),
    ],
    swiftLanguageModes: [.v6]
)

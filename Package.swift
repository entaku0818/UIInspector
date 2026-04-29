// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "UIInspector",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "UIInspector", targets: ["UIInspector"])
    ],
    targets: [
        .target(
            name: "UIInspector",
            path: "Sources/UIInspector"
        ),
        .testTarget(
            name: "UIInspectorTests",
            dependencies: ["UIInspector"],
            path: "Tests/UIInspectorTests"
        )
    ]
)

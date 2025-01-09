// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "relux-appsflyer",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "ReluxAppsFlyer",
            targets: ["ReluxAppsFlyer"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/ivalx1s/darwin-relux.git", .upToNextMajor(from: "5.1.0")),
        .package(url: "https://github.com/AppsFlyerSDK/AppsFlyerFramework-Dynamic", .upToNextMajor(from: "6.15.0")),
    ],
    targets: [
        .target(
            name: "ReluxAppsFlyer",
            dependencies: [
                .product(name: "Relux", package: "darwin-relux"),
                .product(name: "AppsFlyerLib-Dynamic", package: "AppsFlyerFramework-Dynamic"),
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "ReluxAppsFlyerTests",
            dependencies: ["ReluxAppsFlyer"],
            path: "Tests"
        ),
    ]
)

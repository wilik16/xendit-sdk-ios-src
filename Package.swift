// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Xendit",
    // Supported platforms
    platforms: [
        .iOS(.v9)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Xendit",
            targets: ["Xendit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/AliSoftware/OHHTTPStubs.git", from: "9.1.0"),
        .package(name: "Sentry", url: "https://github.com/getsentry/sentry-cocoa", from: "7.12.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Xendit",
            dependencies: ["XenditObjC", "CardinalMobile", "Sentry"],
            exclude: ["Info.plist"]),
        .target(
            name: "XenditObjC",
            dependencies: [],
            exclude: ["Log/LogDNA/LICENSE"]),
        .binaryTarget(
            name: "CardinalMobile",
            path: "CardinalMobile.xcframework"),
        .testTarget(
            name: "XenditTests",
            dependencies: [
                "Xendit",
                "XenditObjC",
                "Sentry",
                "OHHTTPStubs",
                .product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs"),
            ],
            exclude: ["Info.plist"],
            resources: [
                .process("StubResponses"),
            ]),
    ]
)

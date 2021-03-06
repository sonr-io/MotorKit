// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MotorKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MotorKit",
            targets: ["MotorKit", "Motor", "SecurityExtensions"]
        ),

    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-protobuf.git", .upToNextMajor(from: "1.0.0")),
        .package(
            url: "https://github.com/iosdevzone/IDZSwiftCommonCrypto",
            from: "0.13.1"
        ),
        .package(url: "https://github.com/square/Valet.git", .upToNextMajor(from: "4.1.2"))

    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.\
        .binaryTarget(
            name: "Motor",
            path: "./Frameworks/Motor.xcframework"
        ),

        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MotorKit",
            dependencies: [
                "Motor",
                "SecurityExtensions",
                "Valet",
                .product(name: "SwiftProtobuf", package: "swift-protobuf")
            ],
            path: "./Sources/MotorKit",
            exclude: ["buf.gen.yaml"]
        ),
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SecurityExtensions",
            dependencies: [
                "IDZSwiftCommonCrypto"
                          ],
            path: "./Sources/SecurityExtensions",
            exclude: ["Info.plist"]
        ),
        .testTarget(
            name: "MotorKitTests",
            dependencies: ["MotorKit", "Motor"]),
    ]
)

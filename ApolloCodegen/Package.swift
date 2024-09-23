// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OurApolloCodegen",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .tvOS(.v15),
        .macCatalyst(.v15),
        .watchOS(.v8),
    ],
    products: [
        .executable(name: "OurApolloCodegen", targets: ["OurApolloCodegen"])
    ],
    dependencies: [
        // The actual Apollo library
        .package(
            url: "https://github.com/apollographql/apollo-ios-codegen.git",
            .revisionItem("1.15.1")
        ),

        // The official Swift argument parser.
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            .exactItem("1.4.0")
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "OurApolloCodegen",
            dependencies: [
                .product(name: "ApolloCodegenLib", package: "apollo-ios-codegen"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        )
    ]
)

// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "InitialsImageView",
    platforms: [
        .iOS(.v8)
    ],
    products: [
        .library(
            name: "InitialsImageView",
            targets: ["InitialsImageView"]),
    ],
    targets: [
        .target(
            name: "InitialsImageView",
            dependencies: [],
            path: "",
            exclude: ["InitialsImageViewSampleSwift", "README.md", "LICENSE", "InitialsImageView.podspec"],
            sources: ["InitialsImageView.swift"])
    ],
    swiftLanguageVersions: [.v5]
)

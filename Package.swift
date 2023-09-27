// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "swiftdata-sectionedquery",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "SectionedQuery",
            targets: ["SectionedQuery"]),
    ],
    targets: [
        .target(
            name: "SectionedQuery")
    ]
)

// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "GCDWebServer",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v12),
        .tvOS(.v12),
    ],
    products: [
        .library(
            name: "GCDWebServer",
            targets: ["GCDWebServer"]),
    ],
    targets: [
        .target(
            name: "GCDWebServer",
            path: ".",
            exclude: [
                "Frameworks",
                "iOS",
                "Mac",
                "Tests",
                "tvOS",
                "Package.swift",
                "GCDWebServer.podspec",
                "Run-Tests.sh",
                "format-source.sh",
                "README.md",
                "LICENSE",
            ],
            resources: [
                .copy("GCDWebUploader/GCDWebUploader.bundle"),
            ],
            cSettings: [
                .headerSearchPath("GCDWebServer/Core"),
                .headerSearchPath("GCDWebServer/Requests"),
                .headerSearchPath("GCDWebServer/Responses"),
            ]
        ),
        .testTarget(
            name: "GCDWebServerTests",
            dependencies: ["GCDWebServer"],
            path: "Frameworks",
            exclude: [
                "Info.plist",
            ]
        ),
    ]
)

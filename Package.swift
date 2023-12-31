// swift-tools-version: 5.8

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Example",
    platforms: [
        .iOS("16.0")
    ],
    products: [
        .library(
            name: "ExampleKit",
            targets: ["ExampleKit"]
        ),  
        .iOSApplication(
            name: "ExampleApp",
            targets: ["ExampleAppModule"],
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .tv),
            accentColor: .presetColor(.brown),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ]
        )
    ],
    targets: [ 
        .target(
            name: "ExampleKit",
            dependencies: []
        ),
        .executableTarget(
            name: "ExampleAppModule",
            dependencies: ["ExampleKit"],
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals")
            ]
        )
    ]
)

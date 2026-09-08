// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-buffer-ring",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [

        .library(name: "Buffer Ring Primitive", targets: ["Buffer Ring Primitive"]),
        .library(name: "Buffer Ring Bounded Primitive", targets: ["Buffer Ring Bounded Primitive"]),

        .library(name: "Buffer Ring", targets: ["Buffer Ring"]),
        .library(
            name: "Buffer Ring Bounded",
            targets: ["Buffer Ring Bounded"]
        ),
        .library(
            name: "Buffer Ring Test Support",
            targets: ["Buffer Ring Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-cardinal-tagged.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-ordinal-cardinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-ordinal-tagged.git",
            branch: "main"
        ),
        .package(url: "https://github.com/swift-atoms/swift-cyclic.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-store.git", branch: "main"),
        .package(
            url: "https://github.com/swift-atoms/swift-buffer.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-storage.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-storage-memory.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-memory-allocation.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-span.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-cyclic-index.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-index.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-difference.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-ordinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-memory.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-sequence.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-iterator.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-cardinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-tagged.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-property.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-ownership.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-property-ownership.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-memory-small.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Buffer Ring Primitive",
            dependencies: [
                .product(name: "Buffer", package: "swift-buffer"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Cardinal Tagged", package: "swift-cardinal-tagged"),
                .product(name: "Ordinal Cardinal", package: "swift-ordinal-cardinal"),
                .product(name: "Ordinal Tagged", package: "swift-ordinal-tagged"),
                .product(name: "Ownership", package: "swift-ownership"),
                .product(name: "Span", package: "swift-span"),
                .product(name: "Store", package: "swift-store"),
                .product(name: "Cyclic", package: "swift-cyclic"),
                .product(name: "Iterator", package: "swift-iterator"),
                .product(name: "Storage", package: "swift-storage"),
                .product(name: "Storage Memory", package: "swift-storage-memory"),
                .product(
                    name: "Memory Allocator",
                    package: "swift-memory-allocation"
                ),
                .product(
                    name: "Memory Allocator Protocol",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Memory Small", package: "swift-memory-small"),
                .product(name: "Cyclic Index", package: "swift-cyclic-index"),
                .product(name: "Index", package: "swift-index"),
                .product(
                    name: "Difference",
                    package: "swift-difference"
                ),
                .product(
                    name: "Ordinal",
                    package: "swift-ordinal"
                ),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Property", package: "swift-property"),
                .product(name: "Property Ownership", package: "swift-property-ownership"),
            ]
        ),
        .target(
            name: "Buffer Ring Bounded Primitive",
            dependencies: [
                .product(name: "Buffer", package: "swift-buffer"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Cardinal Tagged", package: "swift-cardinal-tagged"),
                .product(name: "Ordinal Cardinal", package: "swift-ordinal-cardinal"),
                .product(name: "Ordinal Tagged", package: "swift-ordinal-tagged"),
                .product(name: "Ownership", package: "swift-ownership"),
                .product(name: "Span", package: "swift-span"),
                .product(name: "Store", package: "swift-store"),
                .product(name: "Iterator", package: "swift-iterator"),
                "Buffer Ring Primitive",
                .product(name: "Storage", package: "swift-storage"),
                .product(name: "Storage Memory", package: "swift-storage-memory"),
                .product(
                    name: "Memory Allocator",
                    package: "swift-memory-allocation"
                ),
                .product(
                    name: "Memory Allocator Protocol",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Memory Small", package: "swift-memory-small"),
                .product(name: "Cyclic Index", package: "swift-cyclic-index"),
                .product(name: "Index", package: "swift-index"),
                .product(
                    name: "Difference",
                    package: "swift-difference"
                ),
                .product(
                    name: "Ordinal",
                    package: "swift-ordinal"
                ),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Property", package: "swift-property"),
                .product(name: "Property Ownership", package: "swift-property-ownership"),
            ]
        ),

        .target(
            name: "Buffer Ring",
            dependencies: [
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Cardinal Tagged", package: "swift-cardinal-tagged"),
                .product(name: "Ordinal Cardinal", package: "swift-ordinal-cardinal"),
                .product(name: "Ordinal Tagged", package: "swift-ordinal-tagged"),
                .product(name: "Ownership", package: "swift-ownership"),
                .product(name: "Span", package: "swift-span"),
                .product(name: "Store", package: "swift-store"),
                .product(name: "Iterator", package: "swift-iterator"),
                "Buffer Ring Primitive",
                "Buffer Ring Bounded",
                .product(name: "Storage", package: "swift-storage"),
                .product(name: "Cyclic Index", package: "swift-cyclic-index"),
                .product(name: "Index", package: "swift-index"),
                .product(
                    name: "Difference",
                    package: "swift-difference"
                ),
                .product(
                    name: "Ordinal",
                    package: "swift-ordinal"
                ),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),
        .target(
            name: "Buffer Ring Bounded",
            dependencies: [
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Cardinal Tagged", package: "swift-cardinal-tagged"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Ordinal Cardinal", package: "swift-ordinal-cardinal"),
                .product(name: "Ordinal Tagged", package: "swift-ordinal-tagged"),
                .product(name: "Ownership", package: "swift-ownership"),
                .product(name: "Span", package: "swift-span"),
                .product(name: "Store", package: "swift-store"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Iterator", package: "swift-iterator"),
                "Buffer Ring Bounded Primitive",
            ]
        ),

        .target(
            name: "Buffer Ring Test Support",
            dependencies: [
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Cardinal Tagged", package: "swift-cardinal-tagged"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Ordinal Cardinal", package: "swift-ordinal-cardinal"),
                .product(name: "Ordinal Tagged", package: "swift-ordinal-tagged"),
                .product(name: "Ownership", package: "swift-ownership"),
                .product(name: "Span", package: "swift-span"),
                .product(name: "Store", package: "swift-store"),
                .product(name: "Iterator", package: "swift-iterator"),
                "Buffer Ring",
                "Buffer Ring Bounded",
                .product(name: "Storage", package: "swift-storage"),
                .product(name: "Storage Memory", package: "swift-storage-memory"),
                .product(
                    name: "Memory Allocator",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Memory Small", package: "swift-memory-small"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Tagged", package: "swift-tagged"),
            ],
            path: "Tests/Support"
        ),

        .testTarget(
            name: "Buffer Ring Tests",
            dependencies: [
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Cardinal Tagged", package: "swift-cardinal-tagged"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Ordinal Cardinal", package: "swift-ordinal-cardinal"),
                .product(name: "Ordinal Tagged", package: "swift-ordinal-tagged"),
                .product(name: "Ownership", package: "swift-ownership"),
                .product(name: "Span", package: "swift-span"),
                .product(name: "Store", package: "swift-store"),
                .product(name: "Iterator", package: "swift-iterator"),
                "Buffer Ring",
                "Buffer Ring Test Support",
                .product(name: "Storage", package: "swift-storage"),
                .product(name: "Storage Memory", package: "swift-storage-memory"),
                .product(name: "Memory Small", package: "swift-memory-small"),
                .product(name: "Memory", package: "swift-memory"),
                .product(
                    name: "Memory Allocator",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(
                    name: "Cardinal",
                    package: "swift-cardinal"
                ),
                .product(
                    name: "Ordinal",
                    package: "swift-ordinal"
                ),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(
                    name: "Tagged",
                    package: "swift-tagged"
                ),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = [
        .enableExperimentalFeature("BuiltinModule"),
        .enableExperimentalFeature("RawLayout"),
    ]

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}

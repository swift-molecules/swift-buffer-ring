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
            url: "https://github.com/swift-atoms/swift-affine.git",
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
                .product(name: "Buffer Protocol", package: "swift-buffer"),
                .product(name: "Sequence Drain", package: "swift-sequence"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Cardinal Carrier", package: "swift-cardinal"),
                .product(name: "Cardinal Tagged", package: "swift-cardinal"),
                .product(name: "Ordinal Cardinal", package: "swift-ordinal"),
                .product(name: "Ordinal Protocol", package: "swift-ordinal"),
                .product(name: "Ordinal Tagged", package: "swift-ordinal"),
                .product(name: "Ownership Borrow", package: "swift-ownership"),
                .product(name: "Ownership Inout", package: "swift-ownership"),
                .product(name: "Span Protocol", package: "swift-span"),
                .product(name: "Store", package: "swift-store"),
                .product(name: "Cyclic", package: "swift-cyclic"),
                .product(name: "Cyclic Group Static", package: "swift-cyclic"),
                .product(name: "Cyclic Group Static Element", package: "swift-cyclic"),
                .product(name: "Store Protocol", package: "swift-store"),
                .product(name: "Store Operations", package: "swift-store"),
                .product(name: "Store Initialization", package: "swift-store"),
                .product(name: "Store Ledgered", package: "swift-store"),
                .product(name: "Iterable", package: "swift-iterator"),
                .product(name: "Iterator Chunk", package: "swift-iterator"),
                .product(name: "Sequence Protocol", package: "swift-sequence"),
                .product(name: "Buffer", package: "swift-buffer"),
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
                .product(name: "Span", package: "swift-span"),
                .product(name: "Cyclic Index", package: "swift-cyclic-index"),
                .product(name: "Index", package: "swift-index"),
                .product(
                    name: "Affine Standard Library Integration",
                    package: "swift-affine"
                ),
                .product(name: "Affine Tagged", package: "swift-affine"),
                .product(
                    name: "Ordinal Standard Library Integration",
                    package: "swift-ordinal"
                ),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Ordinal Comparison", package: "swift-ordinal"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Property", package: "swift-property"),
                .product(name: "Ownership", package: "swift-ownership"),
                .product(name: "Property Ownership", package: "swift-property-ownership"),
            ]
        ),
        .target(
            name: "Buffer Ring Bounded Primitive",
            dependencies: [
                .product(name: "Buffer Protocol", package: "swift-buffer"),
                .product(name: "Sequence Drain", package: "swift-sequence"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Cardinal Carrier", package: "swift-cardinal"),
                .product(name: "Cardinal Tagged", package: "swift-cardinal"),
                .product(name: "Ordinal Cardinal", package: "swift-ordinal"),
                .product(name: "Ordinal Protocol", package: "swift-ordinal"),
                .product(name: "Ordinal Tagged", package: "swift-ordinal"),
                .product(name: "Ownership Borrow", package: "swift-ownership"),
                .product(name: "Ownership Inout", package: "swift-ownership"),
                .product(name: "Span Protocol", package: "swift-span"),
                .product(name: "Store", package: "swift-store"),
                .product(name: "Store Protocol", package: "swift-store"),
                .product(name: "Store Operations", package: "swift-store"),
                .product(name: "Store Initialization", package: "swift-store"),
                .product(name: "Store Ledgered", package: "swift-store"),
                .product(name: "Iterable", package: "swift-iterator"),
                .product(name: "Iterator Chunk", package: "swift-iterator"),
                .product(name: "Sequence Protocol", package: "swift-sequence"),
                "Buffer Ring Primitive",
                .product(name: "Buffer", package: "swift-buffer"),
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
                .product(name: "Span", package: "swift-span"),
                .product(name: "Cyclic Index", package: "swift-cyclic-index"),
                .product(name: "Index", package: "swift-index"),
                .product(
                    name: "Affine Standard Library Integration",
                    package: "swift-affine"
                ),
                .product(name: "Affine Tagged", package: "swift-affine"),
                .product(
                    name: "Ordinal Standard Library Integration",
                    package: "swift-ordinal"
                ),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Ordinal Comparison", package: "swift-ordinal"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Property", package: "swift-property"),
                .product(name: "Ownership", package: "swift-ownership"),
                .product(name: "Property Ownership", package: "swift-property-ownership"),
            ]
        ),

        .target(
            name: "Buffer Ring",
            dependencies: [
                .product(name: "Sequence Drain", package: "swift-sequence"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Cardinal Carrier", package: "swift-cardinal"),
                .product(name: "Cardinal Tagged", package: "swift-cardinal"),
                .product(name: "Ordinal Cardinal", package: "swift-ordinal"),
                .product(name: "Ordinal Protocol", package: "swift-ordinal"),
                .product(name: "Ordinal Tagged", package: "swift-ordinal"),
                .product(name: "Ownership Borrow", package: "swift-ownership"),
                .product(name: "Ownership Inout", package: "swift-ownership"),
                .product(name: "Span Protocol", package: "swift-span"),
                .product(name: "Store", package: "swift-store"),
                .product(name: "Store Protocol", package: "swift-store"),
                .product(name: "Store Operations", package: "swift-store"),
                .product(name: "Store Initialization", package: "swift-store"),
                .product(name: "Store Ledgered", package: "swift-store"),
                .product(name: "Iterable", package: "swift-iterator"),
                .product(name: "Iterator Chunk", package: "swift-iterator"),
                .product(name: "Sequence Protocol", package: "swift-sequence"),
                "Buffer Ring Primitive",
                "Buffer Ring Bounded",
                .product(name: "Storage", package: "swift-storage"),
                .product(name: "Span", package: "swift-span"),
                .product(name: "Cyclic Index", package: "swift-cyclic-index"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Iterator", package: "swift-iterator"),
                .product(
                    name: "Affine Standard Library Integration",
                    package: "swift-affine"
                ),
                .product(
                    name: "Ordinal Standard Library Integration",
                    package: "swift-ordinal"
                ),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Ordinal Comparison", package: "swift-ordinal"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),
        .target(
            name: "Buffer Ring Bounded",
            dependencies: [
                .product(name: "Sequence Drain", package: "swift-sequence"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Cardinal Carrier", package: "swift-cardinal"),
                .product(name: "Cardinal Tagged", package: "swift-cardinal"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Ordinal Cardinal", package: "swift-ordinal"),
                .product(name: "Ordinal Protocol", package: "swift-ordinal"),
                .product(name: "Ordinal Tagged", package: "swift-ordinal"),
                .product(name: "Ownership Borrow", package: "swift-ownership"),
                .product(name: "Ownership Inout", package: "swift-ownership"),
                .product(name: "Span Protocol", package: "swift-span"),
                .product(name: "Store", package: "swift-store"),
                .product(name: "Store Protocol", package: "swift-store"),
                .product(name: "Store Operations", package: "swift-store"),
                .product(name: "Store Initialization", package: "swift-store"),
                .product(name: "Store Ledgered", package: "swift-store"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Iterable", package: "swift-iterator"),
                .product(name: "Iterator Chunk", package: "swift-iterator"),
                .product(name: "Sequence Protocol", package: "swift-sequence"),
                "Buffer Ring Bounded Primitive",
                .product(name: "Sequence", package: "swift-sequence"),
            ]
        ),

        .target(
            name: "Buffer Ring Test Support",
            dependencies: [
                .product(name: "Sequence Drain", package: "swift-sequence"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Cardinal Carrier", package: "swift-cardinal"),
                .product(name: "Cardinal Tagged", package: "swift-cardinal"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Ordinal Cardinal", package: "swift-ordinal"),
                .product(name: "Ordinal Protocol", package: "swift-ordinal"),
                .product(name: "Ordinal Tagged", package: "swift-ordinal"),
                .product(name: "Ownership Borrow", package: "swift-ownership"),
                .product(name: "Ownership Inout", package: "swift-ownership"),
                .product(name: "Span Protocol", package: "swift-span"),
                .product(name: "Store", package: "swift-store"),
                .product(name: "Store Protocol", package: "swift-store"),
                .product(name: "Store Operations", package: "swift-store"),
                .product(name: "Store Initialization", package: "swift-store"),
                .product(name: "Store Ledgered", package: "swift-store"),
                .product(name: "Iterable", package: "swift-iterator"),
                .product(name: "Iterator Chunk", package: "swift-iterator"),
                .product(name: "Sequence Protocol", package: "swift-sequence"),
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
                .product(name: "Sequence Drain", package: "swift-sequence"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Cardinal Carrier", package: "swift-cardinal"),
                .product(name: "Cardinal Tagged", package: "swift-cardinal"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Ordinal Cardinal", package: "swift-ordinal"),
                .product(name: "Ordinal Protocol", package: "swift-ordinal"),
                .product(name: "Ordinal Tagged", package: "swift-ordinal"),
                .product(name: "Ownership Borrow", package: "swift-ownership"),
                .product(name: "Ownership Inout", package: "swift-ownership"),
                .product(name: "Span Protocol", package: "swift-span"),
                .product(name: "Store", package: "swift-store"),
                .product(name: "Store Protocol", package: "swift-store"),
                .product(name: "Store Operations", package: "swift-store"),
                .product(name: "Store Initialization", package: "swift-store"),
                .product(name: "Store Ledgered", package: "swift-store"),
                .product(name: "Iterable", package: "swift-iterator"),
                .product(name: "Iterator Chunk", package: "swift-iterator"),
                .product(name: "Sequence Protocol", package: "swift-sequence"),
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
                    name: "Cardinal Standard Library Integration",
                    package: "swift-cardinal"
                ),
                .product(
                    name: "Ordinal Standard Library Integration",
                    package: "swift-ordinal"
                ),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(
                    name: "Tagged Standard Library Integration",
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

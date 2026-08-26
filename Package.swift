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
            url: "https://github.com/swift-molecules/swift-buffer.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-storage.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-memory-allocation.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-span.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-cyclic-index.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-index.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-affine.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-ordinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-memory.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-sequence.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-iterator.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-memory-heap.git",
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
                .product(name: "Buffer Primitive", package: "swift-buffer"),
                .product(name: "Buffer Protocol", package: "swift-buffer"),
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
                .product(name: "Memory Heap", package: "swift-memory-heap"),
                .product(
                    name: "Memory Allocator Primitive",
                    package: "swift-memory-allocation"
                ),
                .product(
                    name: "Memory Allocator Protocol",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Storage Protocol", package: "swift-storage"),
                .product(name: "Store Protocol", package: "swift-storage"),
                .product(name: "Span Protocol", package: "swift-span"),
                .product(
                    name: "Store Initialization",
                    package: "swift-storage"
                ),
                .product(name: "Store Ledgered", package: "swift-storage"),
                .product(name: "Cyclic Index", package: "swift-cyclic-index"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Affine", package: "swift-affine"),
                .product(name: "Ordinal", package: "swift-ordinal"),
            ]
        ),
        .target(
            name: "Buffer Ring Bounded Primitive",
            dependencies: [
                "Buffer Ring Primitive",
                .product(name: "Buffer Primitive", package: "swift-buffer"),
                .product(name: "Buffer Protocol", package: "swift-buffer"),
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
                .product(name: "Memory Heap", package: "swift-memory-heap"),
                .product(
                    name: "Memory Allocator Primitive",
                    package: "swift-memory-allocation"
                ),
                .product(
                    name: "Memory Allocator Protocol",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Storage Protocol", package: "swift-storage"),
                .product(name: "Store Protocol", package: "swift-storage"),
                .product(name: "Span Protocol", package: "swift-span"),
                .product(
                    name: "Store Initialization",
                    package: "swift-storage"
                ),
                .product(name: "Store Ledgered", package: "swift-storage"),
                .product(name: "Cyclic Index", package: "swift-cyclic-index"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Affine", package: "swift-affine"),
                .product(name: "Ordinal", package: "swift-ordinal"),
            ]
        ),

        .target(
            name: "Buffer Ring",
            dependencies: [
                "Buffer Ring Primitive",
                "Buffer Ring Bounded",
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
                .product(name: "Memory Heap", package: "swift-memory-heap"),
                .product(
                    name: "Memory Allocator Primitive",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Storage Protocol", package: "swift-storage"),
                .product(name: "Store Protocol", package: "swift-storage"),
                .product(name: "Span Protocol", package: "swift-span"),
                .product(name: "Cyclic Index", package: "swift-cyclic-index"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Iterable", package: "swift-iterator"),
                .product(name: "Iterator Chunk", package: "swift-iterator"),
            ]
        ),
        .target(
            name: "Buffer Ring Bounded",
            dependencies: [
                "Buffer Ring Bounded Primitive",
                "Buffer Ring Primitive",
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
                .product(name: "Memory Heap", package: "swift-memory-heap"),
                .product(
                    name: "Memory Allocator Primitive",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Storage Protocol", package: "swift-storage"),
                .product(name: "Store Protocol", package: "swift-storage"),
                .product(name: "Span Protocol", package: "swift-span"),
                .product(name: "Cyclic Index", package: "swift-cyclic-index"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Iterable", package: "swift-iterator"),
                .product(name: "Iterator Chunk", package: "swift-iterator"),
            ]
        ),

        .target(
            name: "Buffer Ring Test Support",
            dependencies: [
                "Buffer Ring",
                "Buffer Ring Bounded",
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
                .product(name: "Memory Heap", package: "swift-memory-heap"),
                .product(
                    name: "Memory Allocator Primitive",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Storage Protocol", package: "swift-storage"),
                .product(
                    name: "Memory Test Support",
                    package: "swift-memory"
                ),
            ],
            path: "Tests/Support"
        ),

        .testTarget(
            name: "Buffer Ring Tests",
            dependencies: [
                "Buffer Ring",
                .product(name: "Sequence Hint", package: "swift-sequence"),
                "Buffer Ring Test Support",
                .product(
                    name: "Buffer Test Support",
                    package: "swift-buffer"
                ),
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
                .product(name: "Memory Heap", package: "swift-memory-heap"),
                .product(name: "Memory Small", package: "swift-memory-small"),
                .product(
                    name: "Memory Allocator Primitive",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Storage Protocol", package: "swift-storage"),
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

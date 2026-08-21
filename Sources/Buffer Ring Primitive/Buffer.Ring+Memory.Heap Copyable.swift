import Affine_Primitives_Standard_Library_Integration
import Ordinal_Primitives_Standard_Library_Integration

extension Buffer.Ring where S: ~Copyable, S.Element: Copyable {

    @inlinable
    public static func linearize(
        header: Header,
        source: borrowing Storage<Memory.Allocator<Memory.Heap>>.Contiguous<S.Element>,
        to destination: inout Storage<Memory.Allocator<Memory.Heap>>.Contiguous<S.Element>
    ) {
        header.initialization.linearize { range, offset in
            guard !range.isEmpty else { return }
            var src = range.lowerBound
            var dst = offset
            while src < range.upperBound {
                destination.initialize(at: dst, to: source[src])
                src = src.successor.saturating()
                dst = dst.successor.saturating()
            }
        }
    }

    @inlinable
    public static func copy(
        header: Header,
        source: borrowing Storage<Memory.Allocator<Memory.Heap>>.Contiguous<S.Element>,
        to destination: inout Storage<Memory.Allocator<Memory.Heap>>.Contiguous<S.Element>
    ) {
        linearize(header: header, source: source, to: &destination)
    }
}

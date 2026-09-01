public import Sequence_Protocol
public import Iterator_Chunk
public import Iterable
public import Index
public import Tagged
public import Store_Ledgered
public import Store_Initialization
public import Store_Operations
public import Store_Protocol
public import Store
public import Span_Protocol
public import Ownership_Inout
public import Ownership_Borrow
public import Ordinal_Tagged
public import Ordinal_Protocol
public import Ordinal_Cardinal
public import Ordinal
public import Cardinal_Tagged
public import Cardinal_Carrier
public import Memory_Small
public import Affine_Standard_Library_Integration
public import Ordinal_Standard_Library_Integration

extension Buffer.Ring where S: ~Copyable, S.Element: Copyable {

    @inlinable
    public static func linearize(
        header: Header,
        source: borrowing Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<S.Element>,
        to destination: inout Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<S.Element>
    ) {
        header.initialization.linearize { range, offset in
            guard !range.isEmpty else { return }
            var src = range.lowerBound
            var dst = offset
            while src < range.upperBound {
                destination.initialize(at: dst, to: source[src])
                src = (src + .one)
                dst = (dst + .one)
            }
        }
    }

    @inlinable
    public static func copy(
        header: Header,
        source: borrowing Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<S.Element>,
        to destination: inout Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<S.Element>
    ) {
        linearize(header: header, source: source, to: &destination)
    }
}

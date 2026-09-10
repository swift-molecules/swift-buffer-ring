import Sequence
import Iterator
import Index
public import Tagged
public import Store
import Span
import Ownership
import Ordinal_Tagged
import Ordinal_Cardinal
public import Ordinal
import Cardinal_Tagged
public import Cardinal
public import Memory_Small
import Difference
public import Ordinal

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

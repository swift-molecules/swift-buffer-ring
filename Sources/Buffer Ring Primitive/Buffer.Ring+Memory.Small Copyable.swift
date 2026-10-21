public import Cardinal
import Carrier
import Difference
import Index
import Iterator
public import Memory
public import Memory_Allocator_Protocol
import Memory_Small
public import Ordinal
import Ownership
import Property
import Sequence
import Span
public import Store
public import Tagged

extension Buffer.Ring where S: ~Copyable, S.Element: Copyable {

    @inlinable
    public static func linearize<Resource: Memory.Growable & ~Copyable>(
        header: Header,
        source: borrowing Storage<Memory.Allocator<Resource>>.Contiguous<S.Element>,
        to destination: inout Storage<Memory.Allocator<Resource>>.Contiguous<S.Element>
    ) {
        header.initialization.linearize { range, offset in
            guard !range.isEmpty else { return }
            var src = range.lowerBound
            var dst = offset
            while src < range.upperBound {
                destination.initialize(at: dst, to: source[src])
                src = (src + Tagged<S.Element, Cardinal>.one)
                dst = (dst + Tagged<S.Element, Cardinal>.one)
            }
        }
    }

    @inlinable
    public static func copy<Resource: Memory.Growable & ~Copyable>(
        header: Header,
        source: borrowing Storage<Memory.Allocator<Resource>>.Contiguous<S.Element>,
        to destination: inout Storage<Memory.Allocator<Resource>>.Contiguous<S.Element>
    ) {
        linearize(header: header, source: source, to: &destination)
    }
}

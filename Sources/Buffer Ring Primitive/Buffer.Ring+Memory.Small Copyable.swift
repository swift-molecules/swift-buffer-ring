public import Memory
import Sequence
import Iterator
import Index
public import Tagged
public import Store
import Span
import Ownership
import Cardinal
import Ordinal
import Property
import Tagged
import Carrier
public import Ordinal
public import Cardinal
public import Memory_Small
import Difference
public import Memory_Allocator_Protocol

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

public import Cardinal
import Carrier
public import Cyclic
public import Difference
public import Index
import Iterator
public import Memory
public import Memory_Allocator
public import Memory_Allocator_Protocol
public import Memory_Small
public import Ordinal
public import Ownership
public import Property
import Sequence
import Span
public import Storage
import Store
public import Tagged

extension Buffer.Ring.Bounded where S: ~Copyable {

    @inlinable
    public init<Element, Resource: Memory.Growable & ~Copyable>(
        _ elements: [Element],
        capacity: UInt
    ) throws(Self.Error) where S == Storage<Memory.Allocator<Resource>>.Contiguous<Element> {
        guard elements.count <= Int(capacity) else { throw .capacityExceeded }
        var buffer = Self(
            minimumCapacity: Tagged<Element, Cardinal>(_unchecked: Cardinal(capacity))
        )
        for element in elements {
            _ = buffer._pushBack(element)
        }
        self = buffer
    }
}

extension Property.Borrow.Typed
where
    Tag == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Ring.Peek,
    Base == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Ring.Bounded,
    Element: Copyable
{

    @inlinable
    public var front: Element {
        base.value.storage[base.value.header.head]
    }

    @inlinable
    public var back: Element {
        return base.value.storage[
            Index.Modular.advanced(
                base.value.header.head,
                by: Index<Element>.Offset(
                    base.value.header.count.subtract.saturating(.one)
                ),
                capacity: base.value.header.capacity
            )
        ]
    }
}

// Canonical Heap views; existing Small views remain available.
extension Property.Borrow.Typed
where
    Tag == Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Ring.Peek,
    Base == Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Ring.Bounded,
    Element: Copyable
{

    @inlinable
    public var front: Element {
        base.value.storage[base.value.header.head]
    }

    @inlinable
    public var back: Element {
        return base.value.storage[
            Index.Modular.advanced(
                base.value.header.head,
                by: Index<Element>.Offset(
                    base.value.header.count.subtract.saturating(.one)
                ),
                capacity: base.value.header.capacity
            )
        ]
    }
}

import Affine_Standard_Library_Integration
public import Index
public import Memory_Allocator_Primitive
public import Memory_Allocator_Protocol
public import Memory_Heap
import Ordinal_Standard_Library_Integration
public import Storage_Contiguous
public import Storage_Primitive

extension Buffer.Ring.Bounded where S: ~Copyable {

    @inlinable
    public init<Element, Resource: Memory.Growable & ~Copyable>(
        _ elements: [Element],
        capacity: UInt
    ) throws(Self.Error) where S == Storage<Memory.Allocator<Resource>>.Contiguous<Element> {
        guard elements.count <= Int(capacity) else { throw .capacityExceeded }
        var buffer = Self(minimumCapacity: Index<Element>.Count(Cardinal(capacity)))
        for element in elements {
            _ = buffer._pushBack(element)
        }
        self = buffer
    }
}

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
                    fromZero: base.value.header.count.subtract.saturating(.one).map(Ordinal.init)
                ),
                capacity: base.value.header.capacity
            )
        ]
    }
}

public import Sequence_Protocol
public import Iterator_Chunk
public import Iterable
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
public import Affine_Tagged
public import Affine_Standard_Library_Integration
public import Cardinal
public import Cyclic_Index
public import Index
public import Memory_Allocator
public import Memory_Allocator_Protocol
public import Memory
public import Memory_Small
public import Ownership
public import Ordinal_Standard_Library_Integration
public import Property
public import Property_Ownership
public import Storage_Memory
public import Storage
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

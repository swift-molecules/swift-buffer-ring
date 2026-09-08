public import Sequence
public import Iterator
public import Store
public import Span
public import Ownership
public import Ordinal_Tagged
public import Ordinal_Cardinal
public import Ordinal
public import Cardinal_Tagged
public import Cardinal
public import Difference
public import Cyclic_Index
public import Index
public import Memory_Allocator
public import Memory
public import Memory_Small
public import Ordinal
public import Property
public import Property_Ownership
public import Storage_Memory
public import Storage
public import Tagged

extension Property.Borrow.Typed
where
    Tag == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Ring.Peek,
    Base == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Ring,
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

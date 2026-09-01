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
public import Memory
public import Memory_Allocator
public import Memory_Small
public import Ownership
public import Property
public import Property_Ownership
public import Storage
public import Storage_Memory

extension Buffer.Ring.Bounded where S: ~Copyable {

    public enum Push {}
}

extension Buffer.Ring.Bounded.Push where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Ring.Push, Buffer<S>.Ring.Bounded>.Inout.Typed<
        S.Element
    >
}

extension Property.Inout.Typed
where
    Tag == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Ring.Push,
    Base == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Ring.Bounded,
    Element: ~Copyable
{

    @inlinable
    @discardableResult
    public mutating func back(_ element: consuming Element) -> Element? {
        base.value._pushBack(consume element)
    }

    @inlinable
    @discardableResult
    public mutating func front(_ element: consuming Element) -> Element? {
        base.value._pushFront(consume element)
    }
}

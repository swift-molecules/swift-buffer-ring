public import Sequence
public import Iterator
public import Index
public import Tagged
public import Store
public import Span
public import Ownership
public import Ordinal_Tagged
public import Ordinal_Cardinal
public import Ordinal
public import Cardinal_Tagged
public import Cardinal
public import Memory
public import Memory_Allocator
public import Memory_Small
public import Property
public import Storage
public import Storage_Memory

extension Buffer.Ring.Bounded where S: ~Copyable {

    public enum Pop {}
}

extension Buffer.Ring.Bounded.Pop where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Ring.Pop, Buffer<S>.Ring.Bounded>.Inout.Typed<
        S.Element
    >
}

extension Property.Inout.Typed
where
    Tag == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Ring.Pop,
    Base == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Ring.Bounded,
    Element: ~Copyable
{

    @inlinable
    public mutating func front() -> Element {
        base.value._popFront()
    }

    @inlinable
    public mutating func back() -> Element {
        base.value._popBack()
    }
}

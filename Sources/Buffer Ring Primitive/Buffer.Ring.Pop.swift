public import Memory
public import Memory_Allocator
public import Memory_Small
public import Ownership
public import Property
public import Property_Ownership
public import Storage
public import Storage_Memory

extension Buffer.Ring where S: ~Copyable {

    public enum Pop {}
}

extension Buffer.Ring.Pop where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Ring.Pop, Buffer<S>.Ring>.Inout.Typed<S.Element>
}

extension Property.Inout.Typed
where
    Tag == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Ring.Pop,
    Base == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Ring,
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

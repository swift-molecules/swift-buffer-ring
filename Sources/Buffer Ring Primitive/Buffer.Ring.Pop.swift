import Sequence
import Iterator
import Index
import Tagged
public import Store
import Span
public import Ownership
import Ordinal_Tagged
import Ordinal_Cardinal
import Ordinal
import Cardinal_Tagged
import Cardinal
public import Memory
public import Memory_Allocator
public import Memory_Small
public import Property
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

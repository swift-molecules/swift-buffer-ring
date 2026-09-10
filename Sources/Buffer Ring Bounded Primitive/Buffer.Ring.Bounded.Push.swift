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

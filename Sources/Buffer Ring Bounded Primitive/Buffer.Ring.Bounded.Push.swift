import Cardinal
import Carrier
import Index
import Iterator
public import Memory
public import Memory_Allocator
public import Memory_Allocator_Protocol
import Memory_Small
import Ordinal
public import Ownership
public import Property
import Sequence
import Span
public import Storage
public import Store
import Tagged

extension Buffer.Ring.Bounded where S: ~Copyable {

    public enum Push {}
}

extension Buffer.Ring.Bounded.Push where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Ring.Push, Buffer<S>.Ring.Bounded>.Inout.Typed<
        S.Element
    >
}

extension Property.Inout.Typed where Base: ~Copyable, Element: ~Copyable {

    @inlinable
    @discardableResult
    public mutating func back<Resource: Memory.Growable & ~Copyable>(_ element: consuming Element) -> Element?
    where
        Tag == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring.Push,
        Base == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring.Bounded
    {
        base.value._pushBack(consume element)
    }

    @inlinable
    @discardableResult
    public mutating func front<Resource: Memory.Growable & ~Copyable>(_ element: consuming Element) -> Element?
    where
        Tag == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring.Push,
        Base == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring.Bounded
    {
        base.value._pushFront(consume element)
    }
}

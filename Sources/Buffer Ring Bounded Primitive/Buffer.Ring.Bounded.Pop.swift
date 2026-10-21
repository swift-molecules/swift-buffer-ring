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

    public enum Pop {}
}

extension Buffer.Ring.Bounded.Pop where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Ring.Pop, Buffer<S>.Ring.Bounded>.Inout.Typed<
        S.Element
    >
}

extension Property.Inout.Typed where Base: ~Copyable, Element: ~Copyable {

    @inlinable
    public mutating func front<Resource: Memory.Growable & ~Copyable>() -> Element
    where
        Tag == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring.Pop,
        Base == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring.Bounded
    {
        base.value._popFront()
    }

    @inlinable
    public mutating func back<Resource: Memory.Growable & ~Copyable>() -> Element
    where
        Tag == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring.Pop,
        Base == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring.Bounded
    {
        base.value._popBack()
    }
}

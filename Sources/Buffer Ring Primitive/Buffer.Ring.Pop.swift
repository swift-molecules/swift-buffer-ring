import Sequence
import Iterator
import Index
import Tagged
public import Store
import Span
public import Ownership
import Cardinal
import Ordinal
import Property
import Carrier
public import Memory
public import Memory_Allocator
public import Memory_Small
public import Property
public import Storage
public import Memory_Allocator_Protocol

extension Buffer.Ring where S: ~Copyable {

    public enum Pop {}
}

extension Buffer.Ring.Pop where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Ring.Pop, Buffer<S>.Ring>.Inout.Typed<S.Element>
}

extension Property.Inout.Typed where Base: ~Copyable, Element: ~Copyable {


    @inlinable
    public mutating func front<Resource: Memory.Growable & ~Copyable>() -> Element
    where Tag == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring.Pop,
    Base == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring {
        base.value._popFront()
    }

    @inlinable
    public mutating func back<Resource: Memory.Growable & ~Copyable>() -> Element
    where Tag == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring.Pop,
    Base == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring {
        base.value._popBack()
    }
}

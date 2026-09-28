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

    public enum Push {}
}

extension Buffer.Ring.Push where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Ring.Push, Buffer<S>.Ring>.Inout.Typed<S.Element>
}

extension Property.Inout.Typed where Base: ~Copyable, Element: ~Copyable {


    @inlinable
    public mutating func back<Resource: Memory.Growable & ~Copyable>(_ element: consuming Element)
    where Tag == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring.Push,
    Base == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring {
        base.value._pushBack(consume element)
    }

    @inlinable
    public mutating func front<Resource: Memory.Growable & ~Copyable>(_ element: consuming Element)
    where Tag == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring.Push,
    Base == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring {
        base.value._pushFront(consume element)
    }
}

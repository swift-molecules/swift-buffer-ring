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

    public enum Remove {}
}

extension Buffer.Ring.Bounded.Remove where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Ring.Remove, Buffer<S>.Ring.Bounded>.Inout.Typed<
        S.Element
    >
}

extension Property.Inout.Typed where Base: ~Copyable, Element: ~Copyable {

    @inlinable
    public mutating func all<Resource: Memory.Growable & ~Copyable>()
    where
        Tag == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring.Remove,
        Base == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring.Bounded
    {
        base.value._removeAll()
    }
}

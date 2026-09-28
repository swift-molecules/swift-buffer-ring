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
    where Tag == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring.Remove,
    Base == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring.Bounded {
        base.value._removeAll()
    }
}

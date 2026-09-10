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

    public enum Remove {}
}

extension Buffer.Ring.Remove where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Ring.Remove, Buffer<S>.Ring>.Inout.Typed<S.Element>
}

extension Property.Inout.Typed
where
    Tag == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Ring.Remove,
    Base == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Ring,
    Element: ~Copyable
{

    @inlinable
    public mutating func all() {
        base.value._removeAll()
    }
}

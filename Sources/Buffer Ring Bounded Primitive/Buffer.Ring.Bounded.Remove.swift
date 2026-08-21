extension Buffer.Ring.Bounded where S: ~Copyable {

    public enum Remove {}
}

extension Buffer.Ring.Bounded.Remove where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Ring.Remove, Buffer<S>.Ring.Bounded>.Inout.Typed<
        S.Element
    >
}

extension Property.Inout.Typed
where
    Tag == Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Ring.Remove,
    Base == Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Ring.Bounded,
    Element: ~Copyable
{

    @inlinable
    public mutating func all() {
        base.value._removeAll()
    }
}

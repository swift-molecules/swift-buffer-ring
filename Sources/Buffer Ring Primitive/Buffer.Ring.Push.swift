extension Buffer.Ring where S: ~Copyable {

    public enum Push {}
}

extension Buffer.Ring.Push where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Ring.Push, Buffer<S>.Ring>.Inout.Typed<S.Element>
}

extension Property.Inout.Typed
where
    Tag == Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Ring.Push,
    Base == Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Ring,
    Element: ~Copyable
{

    @inlinable
    public mutating func back(_ element: consuming Element) {
        base.value._pushBack(consume element)
    }

    @inlinable
    public mutating func front(_ element: consuming Element) {
        base.value._pushFront(consume element)
    }
}

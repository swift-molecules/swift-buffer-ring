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
    Tag == Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Ring.Push,
    Base == Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Ring.Bounded,
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

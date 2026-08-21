extension Buffer.Ring.Bounded where S: ~Copyable {

    public enum Peek {}
}

extension Buffer.Ring.Bounded.Peek where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Ring.Peek, Buffer<S>.Ring.Bounded>.Borrow.Typed<
        S.Element
    >
}

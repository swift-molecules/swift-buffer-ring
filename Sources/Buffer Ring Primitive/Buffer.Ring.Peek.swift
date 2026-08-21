extension Buffer.Ring where S: ~Copyable {

    public enum Peek {}
}

extension Buffer.Ring.Peek where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Ring.Peek, Buffer<S>.Ring>.Borrow.Typed<S.Element>
}

public import Sequence
public import Iterator
public import Index
public import Tagged
public import Store
public import Span
public import Ownership
public import Ordinal_Tagged
public import Ordinal_Cardinal
public import Ordinal
public import Cardinal_Tagged
public import Cardinal
public import Property

extension Buffer.Ring.Bounded where S: ~Copyable {

    public enum Peek {}
}

extension Buffer.Ring.Bounded.Peek where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Ring.Peek, Buffer<S>.Ring.Bounded>.Borrow.Typed<
        S.Element
    >
}

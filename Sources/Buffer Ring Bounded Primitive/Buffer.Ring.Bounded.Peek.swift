import Cardinal
import Carrier
import Index
import Iterator
import Ordinal
import Ownership
public import Property
import Sequence
import Span
public import Store
import Tagged

extension Buffer.Ring.Bounded where S: ~Copyable {

    public enum Peek {}
}

extension Buffer.Ring.Bounded.Peek where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Ring.Peek, Buffer<S>.Ring.Bounded>.Borrow.Typed<
        S.Element
    >
}

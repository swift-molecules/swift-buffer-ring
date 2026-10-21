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

extension Buffer.Ring where S: ~Copyable {

    public enum Peek {}
}

extension Buffer.Ring.Peek where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Ring.Peek, Buffer<S>.Ring>.Borrow.Typed<S.Element>
}

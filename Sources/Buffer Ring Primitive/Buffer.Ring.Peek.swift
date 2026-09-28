import Sequence
import Iterator
import Index
import Tagged
public import Store
import Span
import Ownership
import Cardinal
import Ordinal
import Property
import Carrier
public import Property

extension Buffer.Ring where S: ~Copyable {

    public enum Peek {}
}

extension Buffer.Ring.Peek where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Ring.Peek, Buffer<S>.Ring>.Borrow.Typed<S.Element>
}

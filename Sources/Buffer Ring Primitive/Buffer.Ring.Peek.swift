import Sequence
import Iterator
import Index
import Tagged
public import Store
import Span
import Ownership
import Ordinal_Tagged
import Ordinal_Cardinal
import Ordinal
import Cardinal_Tagged
import Cardinal
public import Property

extension Buffer.Ring where S: ~Copyable {

    public enum Peek {}
}

extension Buffer.Ring.Peek where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Ring.Peek, Buffer<S>.Ring>.Borrow.Typed<S.Element>
}

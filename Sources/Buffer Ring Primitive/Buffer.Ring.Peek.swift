public import Sequence
public import Iterator
public import Index
public import Tagged
public import Store
public import Span
public import Ownership
public import Ordinal_Tagged
public import Ordinal_Protocol
public import Ordinal_Cardinal
public import Ordinal
public import Cardinal_Tagged
public import Cardinal_Carrier
public import Property
public import Property_Ownership

extension Buffer.Ring where S: ~Copyable {

    public enum Peek {}
}

extension Buffer.Ring.Peek where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Ring.Peek, Buffer<S>.Ring>.Borrow.Typed<S.Element>
}

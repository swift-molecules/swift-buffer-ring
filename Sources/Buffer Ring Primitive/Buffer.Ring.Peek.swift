public import Sequence_Protocol
public import Iterator_Chunk
public import Iterable
public import Index
public import Tagged
public import Store_Ledgered
public import Store_Initialization
public import Store_Operations
public import Store_Protocol
public import Store
public import Span_Protocol
public import Ownership_Inout
public import Ownership_Borrow
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

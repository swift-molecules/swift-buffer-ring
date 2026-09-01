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
public import Sequence
public import Span

extension Buffer.Ring: Sequenceable where S: Span.`Protocol`, S: ~Copyable, S.Element: Copyable {

    public typealias Element = S.Element

    @_implements(Sequenceable,Iterator)
    public typealias SequenceableIterator = Buffer<S>.Ring.Scalar

    @inlinable
    @_implements(Sequenceable,makeIterator())
    public consuming func sequenceableMakeIterator() -> Buffer<S>.Ring.Scalar {
        Buffer<S>.Ring.Scalar(self)
    }
}

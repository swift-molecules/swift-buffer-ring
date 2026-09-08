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

public import Sequence
import Iterator
import Index
import Tagged
public import Store
public import Span
import Ownership
import Ordinal_Tagged
import Ordinal_Cardinal
import Ordinal
import Cardinal_Tagged
import Cardinal

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

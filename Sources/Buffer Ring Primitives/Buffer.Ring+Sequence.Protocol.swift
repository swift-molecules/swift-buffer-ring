public import Sequence_Primitives
public import Span_Protocol_Primitives

extension Buffer.Ring: Sequenceable where S: Span.`Protocol`, S: ~Copyable, S.Element: Copyable {

    public typealias Iterator = Buffer<S>.Ring.Scalar

    @inlinable
    public consuming func makeIterator() -> Buffer<S>.Ring.Scalar {
        Buffer<S>.Ring.Scalar(self)
    }
}

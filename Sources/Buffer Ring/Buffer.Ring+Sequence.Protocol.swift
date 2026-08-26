public import Sequence
public import Span_Protocol

extension Buffer.Ring: Sequenceable where S: Span.`Protocol`, S: ~Copyable, S.Element: Copyable {

    public typealias Iterator = Buffer<S>.Ring.Scalar

    @inlinable
    public consuming func makeIterator() -> Buffer<S>.Ring.Scalar {
        Buffer<S>.Ring.Scalar(self)
    }
}

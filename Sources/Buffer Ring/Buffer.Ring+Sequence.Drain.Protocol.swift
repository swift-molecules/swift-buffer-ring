public import Sequence
public import Span_Protocol

extension Buffer.Ring: Sequence.Drain.`Protocol` where S: ~Copyable {

    @inlinable
    public mutating func drain(_ body: (consuming S.Element) -> Void) {
        _drain(body)
    }
}

extension Buffer.Ring where S: Span.`Protocol`, S: ~Copyable, S.Element: Copyable {

    @inlinable
    public mutating func removeAll() {

        _drain { _ in }
    }
}

extension Buffer.Ring where S: ~Copyable {

    @inlinable
    public var drain: Property<Sequence.Drain, Self>.Inout {
        mutating _read {
            yield Property<Sequence.Drain, Self>.Inout(&self)
        }
        mutating _modify {
            var accessor = Property<Sequence.Drain, Self>.Inout(&self)
            yield &accessor
        }
    }
}

import Affine_Standard_Library_Integration
public import Iterable
import Ordinal_Standard_Library_Integration
public import Span_Protocol
public import Store_Protocol

extension Buffer.Ring where S: Span.`Protocol`, S: ~Copyable, S.Element: Copyable {

    public struct Scalar: Iterator_Primitive.Iterator.`Protocol`, ~Copyable {
        @usableFromInline
        var base: Buffer<S>.Ring

        @usableFromInline
        var position: Index<S.Element>

        @inlinable
        package init(_ base: consuming Buffer<S>.Ring) {
            self.base = base
            self.position = .zero
        }
    }
}

extension Buffer.Ring.Scalar where S: Span.`Protocol`, S: ~Copyable, S.Element: Copyable {

    public typealias Failure = Never

    @inlinable
    public mutating func next() -> S.Element? {
        let end = base.count.map(Ordinal.init)
        guard position < end else { return nil }
        defer { position += .one }
        let physical = Buffer.Ring.physicalSlot(forLogical: position, header: base._header)

        return base._storage[physical]
    }
}

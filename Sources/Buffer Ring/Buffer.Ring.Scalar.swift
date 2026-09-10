import Sequence
public import Iterator
public import Store
public import Span
import Ownership
import Ordinal_Tagged
import Ordinal_Cardinal
import Cardinal_Tagged
public import Tagged
public import Cardinal
public import Ordinal
public import Index
import Difference
public import Ordinal
import Storage

extension Buffer.Ring where S: Span.`Protocol`, S: ~Copyable, S.Element: Copyable {

    public struct Scalar: Iterating<S.Element, Never>, ~Copyable {
        @_implements(Iterating,Element)
        public typealias ScalarElement = S.Element

        @_implements(Iterating,Failure)
        public typealias ScalarFailure = Never

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

    @inlinable
    public mutating func next() -> S.Element? {
        let end = base.count.map { Ordinal($0.rawValue) }
        guard position < end else { return nil }
        defer { position = (position + .one) }
        let physical = Buffer.Ring.physicalSlot(forLogical: position, header: base._header)

        return base._storage[physical]
    }
}

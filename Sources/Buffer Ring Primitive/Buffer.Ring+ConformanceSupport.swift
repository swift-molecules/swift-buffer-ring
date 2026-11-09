import Cardinal
import Carrier
import Difference
import Index
import Iterator
import Ordinal
import Ownership
import Property
import Sequence
public import Span
public import Store
import Tagged

extension Buffer.Ring where S: ~Copyable {

    @usableFromInline
    package var _header: Header { header }

    @usableFromInline
    package var _storage: S {
        _read { yield storage }
    }

    @usableFromInline
    package mutating func _drain(_ body: (consuming S.Element) -> Void)
    where S: Store.Ledgered.`Protocol` {
        while !header.isEmpty {
            body(Self.popFront(header: &header, storage: &storage))
        }
        header.head = .zero
        storage.initialization = .empty
    }
}

extension Buffer.Ring where S: Span.`Protocol`, S: ~Copyable {

    @inlinable
    @_lifetime(borrow self)
    package borrowing func _span() -> Swift::Span<S.Element> {
        storage.span
    }
}

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
public import Difference
public import Ordinal

extension Buffer.Ring.Bounded where S: ~Copyable {

    @usableFromInline
    package var _header: Buffer.Ring.Header { header }

    @usableFromInline
    package var _storage: S {
        _read { yield storage }
    }

    @usableFromInline
    package mutating func _drain(_ body: (consuming S.Element) -> Void) {
        while !header.isEmpty {
            let element = storage.move(at: header.head)
            header.head = Index.Modular.successor(of: header.head, capacity: header.capacity)
            header.count = header.count.subtract.saturating(.one)
            body(element)
        }
        header.head = .zero
    }
}

extension Buffer.Ring.Bounded where S: Span.`Protocol`, S: ~Copyable {

    @inlinable
    @_lifetime(borrow self)
    package borrowing func _span() -> Swift.Span<S.Element> {
        storage.span
    }
}

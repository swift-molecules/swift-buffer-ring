import Affine_Standard_Library_Integration
import Ordinal_Standard_Library_Integration
public import Span_Protocol
public import Storage_Contiguous

extension Buffer.Ring where S: ~Copyable {

    @usableFromInline
    package var _header: Header { header }

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

extension Buffer.Ring where S: Span.`Protocol`, S: ~Copyable {

    @inlinable
    @_lifetime(borrow self)
    package borrowing func _span() -> Swift.Span<S.Element> {
        storage.span
    }
}

import Cardinal
import Carrier
import Index
import Iterator
import Ordinal
import Ownership
import Property
public import Sequence
public import Span
public import Store
import Tagged

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

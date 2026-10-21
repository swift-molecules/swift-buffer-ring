import Cardinal
import Carrier
import Index
import Iterator
import Ordinal
import Ownership
import Property
public import Sequence
import Span
public import Store
import Tagged

extension Buffer.Ring.Bounded: Sequence.Drain.`Protocol` where S: ~Copyable {

    @inlinable
    public mutating func drain(_ body: (consuming S.Element) -> Void) {
        _drain(body)
    }
}

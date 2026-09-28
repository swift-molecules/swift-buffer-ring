public import Sequence
import Iterator
import Index
import Tagged
public import Store
import Span
import Ownership
import Cardinal
import Ordinal
import Property
import Carrier

extension Buffer.Ring.Bounded: Sequence.Drain.`Protocol` where S: ~Copyable {

    @inlinable
    public mutating func drain(_ body: (consuming S.Element) -> Void) {
        _drain(body)
    }
}

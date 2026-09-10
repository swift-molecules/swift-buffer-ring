public import Sequence
import Iterator
import Index
import Tagged
public import Store
import Span
import Ownership
import Ordinal_Tagged
import Ordinal_Cardinal
import Ordinal
import Cardinal_Tagged
import Cardinal

extension Buffer.Ring.Bounded: Sequence.Drain.`Protocol` where S: ~Copyable {

    @inlinable
    public mutating func drain(_ body: (consuming S.Element) -> Void) {
        _drain(body)
    }
}

public import Cardinal
import Carrier
import Difference
import Index
import Iterator
public import Ordinal
import Ownership
import Property
import Sequence
import Span
import Storage
public import Store
public import Tagged

extension Buffer.Ring.Bounded where S: ~Copyable {

    @inlinable
    public func forEach(_ body: (borrowing S.Element) -> Void) {
        header.initialization.forEach { range in
            var slot = range.lowerBound
            while slot < range.upperBound {
                body(storage[slot])
                slot += .one
            }
        }
    }
}

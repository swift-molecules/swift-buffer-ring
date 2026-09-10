import Sequence
import Iterator
import Index
public import Tagged
public import Store
import Span
import Ownership
import Ordinal_Tagged
import Ordinal_Cardinal
public import Ordinal
import Cardinal_Tagged
public import Cardinal
import Difference
public import Ordinal
import Storage

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

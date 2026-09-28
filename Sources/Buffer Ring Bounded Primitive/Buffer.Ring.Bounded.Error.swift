import Sequence
import Iterator
import Index
import Tagged
import Store
import Span
import Ownership
import Cardinal
import Ordinal
import Property
import Carrier
extension Buffer.Ring.Bounded where S: ~Copyable {

    public enum Error: Swift.Error, Sendable, Equatable {

        case capacityExceeded
    }
}

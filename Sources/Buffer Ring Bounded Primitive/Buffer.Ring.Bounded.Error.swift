import Sequence
import Iterator
import Index
import Tagged
import Store
import Span
import Ownership
import Ordinal_Tagged
import Ordinal_Cardinal
import Ordinal
import Cardinal_Tagged
import Cardinal
extension Buffer.Ring.Bounded where S: ~Copyable {

    public enum Error: Swift.Error, Sendable, Equatable {

        case capacityExceeded
    }
}

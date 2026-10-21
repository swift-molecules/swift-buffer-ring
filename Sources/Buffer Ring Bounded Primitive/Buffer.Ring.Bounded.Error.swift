import Cardinal
import Carrier
import Index
import Iterator
import Ordinal
import Ownership
import Property
import Sequence
import Span
import Store
import Tagged

extension Buffer.Ring.Bounded where S: ~Copyable {

    public enum Error: Swift::Error, Sendable, Equatable {

        case capacityExceeded
    }
}

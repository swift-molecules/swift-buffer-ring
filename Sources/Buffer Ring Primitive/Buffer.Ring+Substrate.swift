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
import Storage

extension Buffer.Ring where S: ~Copyable {

    @inlinable
    public var substrate: S {
        _read { yield storage }
    }
}

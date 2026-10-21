import Cardinal
import Carrier
import Index
import Iterator
import Ordinal
import Ownership
import Property
import Sequence
import Span
import Storage
import Store
import Tagged

extension Buffer.Ring where S: ~Copyable {

    @inlinable
    public var substrate: S {
        _read { yield storage }
    }
}

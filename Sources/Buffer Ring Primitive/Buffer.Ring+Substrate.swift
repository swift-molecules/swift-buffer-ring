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
import Storage

extension Buffer.Ring where S: ~Copyable {

    @inlinable
    public var substrate: S {
        _read { yield storage }
    }
}

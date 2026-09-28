import Sequence
import Iterator
import Tagged
public import Store
import Span
import Ownership
import Cardinal
import Ordinal
import Property
import Carrier
import Difference
import Index
import Storage

extension Buffer where S: Store.`Protocol`, S: ~Copyable {

    @frozen
    public struct Ring: ~Copyable {

        @usableFromInline
        var header: Header

        @usableFromInline
        var storage: S

        @inlinable
        package init(header: Header, storage: consuming S) {
            self.header = header
            self.storage = storage
        }

    }
}

extension Buffer.Ring: @unsafe @unchecked Sendable
where S: Store.`Protocol` & ~Copyable & Sendable {}

import Cardinal
import Carrier
import Difference
import Index
import Iterator
import Ordinal
import Ownership
import Property
import Sequence
import Span
public import Store
import Tagged

extension Buffer.Ring where S: ~Copyable {

    @frozen
    public struct Bounded: ~Copyable {

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

extension Buffer.Ring.Bounded: @unsafe @unchecked Sendable
where S: Store.`Protocol` & ~Copyable & Sendable {}

import Sequence
import Iterator
import Tagged
public import Store
import Span
import Ownership
import Ordinal_Tagged
import Ordinal_Cardinal
import Ordinal
import Cardinal_Tagged
import Cardinal
import Difference
import Index
import Ordinal
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

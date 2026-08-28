import Affine_Standard_Library_Integration
import Index
import Ordinal_Standard_Library_Integration
public import Storage

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

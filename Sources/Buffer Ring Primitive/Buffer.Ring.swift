public import Sequence_Protocol
public import Iterator_Chunk
public import Iterable
public import Tagged
public import Store_Ledgered
public import Store_Initialization
public import Store_Operations
public import Store_Protocol
public import Store
public import Span_Protocol
public import Ownership_Inout
public import Ownership_Borrow
public import Ordinal_Tagged
public import Ordinal_Protocol
public import Ordinal_Cardinal
public import Ordinal
public import Cardinal_Tagged
public import Cardinal_Carrier
public import Affine_Standard_Library_Integration
public import Index
public import Ordinal_Standard_Library_Integration
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

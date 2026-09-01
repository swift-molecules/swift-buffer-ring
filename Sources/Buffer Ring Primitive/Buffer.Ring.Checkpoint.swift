public import Sequence_Protocol
public import Iterator_Chunk
public import Iterable
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
public import Tagged
public import Cardinal
public import Affine_Standard_Library_Integration
public import Index
public import Ordinal_Standard_Library_Integration

extension Buffer.Ring where S: ~Copyable {

    public struct Checkpoint: Copyable, Sendable {
        @usableFromInline
        package let head: Index<S.Element>

        @usableFromInline
        package let count: Tagged<S.Element, Cardinal>

        @inlinable
        package init(head: Index<S.Element>, count: Tagged<S.Element, Cardinal>) {
            self.head = head
            self.count = count
        }
    }
}

extension Buffer.Ring.Checkpoint: Comparable where S: ~Copyable {

    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.count == rhs.count
    }

    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.count > rhs.count
    }
}

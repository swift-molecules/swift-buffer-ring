public import Sequence
public import Iterator
public import Store
public import Span
public import Ownership
public import Ordinal_Tagged
public import Ordinal_Cardinal
public import Ordinal
public import Cardinal_Tagged
public import Tagged
public import Cardinal
public import Difference
public import Index
public import Ordinal

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

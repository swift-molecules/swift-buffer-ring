import Sequence
import Iterator
public import Store
import Span
import Ownership
import Ordinal_Tagged
import Ordinal_Cardinal
import Ordinal
import Cardinal_Tagged
public import Tagged
public import Cardinal
import Difference
public import Index
import Ordinal

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

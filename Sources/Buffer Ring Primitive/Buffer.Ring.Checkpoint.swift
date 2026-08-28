public import Tagged
public import Cardinal
import Affine_Standard_Library_Integration
import Index
import Ordinal_Standard_Library_Integration

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

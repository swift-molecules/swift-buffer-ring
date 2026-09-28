import Sequence
import Iterator
public import Index
public import Tagged
public import Store
import Span
import Ownership
import Cardinal
import Ordinal
import Property
import Tagged
import Carrier
public import Ordinal
public import Cardinal
public import Difference
public import Cyclic
import Storage

extension Buffer.Ring where S: ~Copyable {

    @inlinable
    public func withFront<R: ~Copyable>(_ body: (borrowing S.Element) -> R) -> R {
        return body(storage[header.head])
    }

    @inlinable
    public func withBack<R: ~Copyable>(_ body: (borrowing S.Element) -> R) -> R {
        return body(
            storage[
                Index.Modular.advanced(
                    header.head,
                    by: Index<S.Element>.Offset(
                        header.count.subtract.saturating(.one)
                    ),
                    capacity: header.capacity
                )
            ]
        )
    }

    @inlinable
    public func peekFront() -> S.Element where S.Element: Copyable {
        withFront { $0 }
    }

    @inlinable
    public func peekBack() -> S.Element where S.Element: Copyable {
        withBack { $0 }
    }
}

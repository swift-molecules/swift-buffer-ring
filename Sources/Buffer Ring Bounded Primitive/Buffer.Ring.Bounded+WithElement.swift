import Affine_Standard_Library_Integration
import Ordinal_Standard_Library_Integration
public import Store_Protocol

extension Buffer.Ring.Bounded where S: ~Copyable {

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
                        fromZero: header.count.subtract.saturating(.one).map(Ordinal.init)
                    ),
                    capacity: header.capacity
                )
            ]
        )
    }
}

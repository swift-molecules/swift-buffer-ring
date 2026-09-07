public import Sequence
public import Iterator
public import Index
public import Tagged
public import Store
public import Span
public import Ownership
public import Ordinal_Tagged
public import Ordinal_Protocol
public import Ordinal_Cardinal
public import Ordinal
public import Cardinal_Tagged
public import Cardinal_Carrier
public import Affine_Tagged
public import Affine_Standard_Library_Integration
public import Cyclic_Index
public import Ordinal_Standard_Library_Integration
public import Storage

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
                        header.count.subtract.saturating(.one)
                    ),
                    capacity: header.capacity
                )
            ]
        )
    }
}

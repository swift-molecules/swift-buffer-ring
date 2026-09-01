public import Sequence_Protocol
public import Iterator_Chunk
public import Iterable
public import Index
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
public import Affine_Tagged
public import Affine_Standard_Library_Integration
public import Cyclic_Index
public import Ordinal_Standard_Library_Integration
public import Storage

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

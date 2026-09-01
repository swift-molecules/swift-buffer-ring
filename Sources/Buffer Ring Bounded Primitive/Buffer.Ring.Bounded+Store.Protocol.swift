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
public import Cardinal_Tagged
public import Cardinal_Carrier
public import Affine_Tagged
public import Affine_Standard_Library_Integration
public import Cardinal
public import Cyclic_Index
public import Index
public import Ordinal
public import Ordinal_Standard_Library_Integration
public import Storage
public import Tagged

extension Buffer.Ring.Bounded: Store.`Protocol` where S: Store.Ledgered.`Protocol`, S: ~Copyable {

    @inlinable
    public subscript(slot: Index<S.Element>) -> S.Element {
        _read {
            yield storage[
                Index.Modular.physical(
                    forLogical: slot,
                    head: header.head,
                    capacity: header.capacity
                )
            ]
        }
        _modify {
            yield &storage[
                Index.Modular.physical(
                    forLogical: slot,
                    head: header.head,
                    capacity: header.capacity
                )
            ]
        }
    }

    @inlinable
    public mutating func initialize(at slot: Index<S.Element>, to element: consuming S.Element) {
        precondition(
            slot == header.count.map { Ordinal($0.rawValue) },
            "ring seam: initialize is lawful only at the back (slot == count)"
        )
        precondition(!header.isFull, "ring seam: initialize on a full ring")
        let tail = Index.Modular.advanced(
            header.head,
            by: Index<S.Element>.Offset(header.count),
            capacity: header.capacity
        )
        storage.initialize(at: tail, to: element)
        header.count = header.count.add.saturating(.one)
        storage.initialization = .init(header)
    }

    @inlinable
    public mutating func move(at slot: Index<S.Element>) -> S.Element {
        precondition(!header.isEmpty, "ring seam: move on an empty ring")
        if slot == .zero {
            let element = storage.move(at: header.head)
            header.head = Index.Modular.successor(of: header.head, capacity: header.capacity)
            header.count = header.count.subtract.saturating(.one)
            storage.initialization = .init(header)
            return element
        }
        let newCount = header.count.subtract.saturating(.one)
        precondition(
            slot == newCount.map { Ordinal($0.rawValue) },
            "ring seam: move is lawful only at the front or the back"
        )
        let last = Index.Modular.advanced(
            header.head,
            by: Index<S.Element>.Offset(newCount),
            capacity: header.capacity
        )
        let element = storage.move(at: last)
        header.count = newCount
        storage.initialization = .init(header)
        return element
    }
}

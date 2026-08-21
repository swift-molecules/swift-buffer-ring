import Affine_Primitives_Standard_Library_Integration
import Cyclic_Index_Primitives
public import Index_Primitives
import Ordinal_Primitives_Standard_Library_Integration
import Store_Initialization_Primitives
public import Store_Ledgered_Primitives
public import Store_Protocol_Primitives

extension Buffer.Ring: Store.`Protocol` where S: Store.Ledgered.`Protocol`, S: ~Copyable {

    @inlinable
    public mutating func initialize(at slot: Index<S.Element>, to element: consuming S.Element) {
        precondition(
            slot == header.count.map(Ordinal.init),
            "ring seam: initialize is lawful only at the back (slot == count)"
        )
        precondition(!header.isFull, "ring seam: initialize on a full ring")
        let tail = Index.Modular.advanced(
            header.head,
            by: Index<S.Element>.Offset(fromZero: header.count.map(Ordinal.init)),
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
            slot == newCount.map(Ordinal.init),
            "ring seam: move is lawful only at the front or the back"
        )
        let last = Index.Modular.advanced(
            header.head,
            by: Index<S.Element>.Offset(fromZero: newCount.map(Ordinal.init)),
            capacity: header.capacity
        )
        let element = storage.move(at: last)
        header.count = newCount
        storage.initialization = .init(header)
        return element
    }
}

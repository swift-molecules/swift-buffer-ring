import Affine_Standard_Library_Integration
import Ordinal_Standard_Library_Integration
public import Storage_Protocol
public import Store_Ledgered
public import Store_Protocol

extension Buffer.Ring where S: ~Copyable {

    @inlinable
    public static func pushBack(
        _ element: consuming S.Element,
        header: inout Header,
        storage: inout S
    ) where S: Store.Ledgered.`Protocol` {
        let countOffset = Index<S.Element>.Offset(fromZero: header.count.map(Ordinal.init))
        let tail = Index.Modular.advanced(header.head, by: countOffset, capacity: header.capacity)

        storage.initialize(at: tail, to: consume element)

        header.count = header.count.add.saturating(.one)

        storage.initialization = header.initialization
    }

    @inlinable
    public static func popFront(
        header: inout Header,
        storage: inout S
    ) -> S.Element where S: Store.Ledgered.`Protocol` {
        let element = storage.move(at: header.head)

        header.head = Index.Modular.successor(of: header.head, capacity: header.capacity)

        header.count = header.count.subtract.saturating(.one)

        storage.initialization = header.initialization

        return element
    }

    @inlinable
    public static func pushFront(
        _ element: consuming S.Element,
        header: inout Header,
        storage: inout S
    ) where S: Store.Ledgered.`Protocol` {
        header.head = Index.Modular.predecessor(of: header.head, capacity: header.capacity)

        storage.initialize(at: header.head, to: consume element)

        header.count = header.count.add.saturating(.one)

        storage.initialization = header.initialization
    }

    @inlinable
    public static func popBack(
        header: inout Header,
        storage: inout S
    ) -> S.Element where S: Store.Ledgered.`Protocol` {
        let newCount = header.count.subtract.saturating(.one)
        let lastOffset = Index<S.Element>.Offset(fromZero: newCount.map(Ordinal.init))
        let lastSlot = Index.Modular.advanced(
            header.head,
            by: lastOffset,
            capacity: header.capacity
        )

        let element = storage.move(at: lastSlot)

        header.count = newCount

        storage.initialization = header.initialization

        return element
    }

    @inlinable
    public static func physicalSlot(
        forLogical logicalIndex: Index<S.Element>,
        header: Header
    ) -> Index<S.Element> {
        Index.Modular.physical(
            forLogical: logicalIndex,
            head: header.head,
            capacity: header.capacity
        )
    }

    @inlinable
    public static func deinitializeAll(
        header: inout Header,
        storage: inout S
    ) where S: Store.Ledgered.`Protocol` {
        while !header.isEmpty {
            _ = popFront(header: &header, storage: &storage)
        }
        header.head = .zero
        storage.initialization = .empty
    }
}

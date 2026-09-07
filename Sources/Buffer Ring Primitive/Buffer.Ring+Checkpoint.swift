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
public import Affine_Standard_Library_Integration
public import Ordinal_Standard_Library_Integration
public import Storage

extension Buffer.Ring where S: ~Copyable {

    @inlinable
    public var checkpoint: Checkpoint {
        Checkpoint(head: header.head, count: header.count)
    }

    @inlinable
    public mutating func restore(to checkpoint: Checkpoint)
    where S: Store.Ledgered.`Protocol` {
        header.head = checkpoint.head
        header.count = checkpoint.count
        storage.initialization = header.initialization
    }
}

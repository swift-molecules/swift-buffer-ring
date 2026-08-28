import Affine_Standard_Library_Integration
import Ordinal_Standard_Library_Integration
public import Storage

extension Buffer.Ring.Bounded where S: ~Copyable {

    @inlinable
    public var checkpoint: Buffer.Ring.Checkpoint {
        Buffer.Ring.Checkpoint(head: header.head, count: header.count)
    }

    @inlinable
    public mutating func restore(to checkpoint: Buffer.Ring.Checkpoint)
    where S: Store.Ledgered.`Protocol` {
        header.head = checkpoint.head
        header.count = checkpoint.count
        storage.initialization = header.initialization
    }
}

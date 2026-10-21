import Cardinal
import Carrier
import Difference
import Index
import Iterator
import Ordinal
import Ownership
import Property
import Sequence
import Span
import Storage
public import Store
import Tagged

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

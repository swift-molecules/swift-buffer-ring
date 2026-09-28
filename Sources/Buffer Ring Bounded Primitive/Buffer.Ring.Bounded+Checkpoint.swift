import Sequence
import Iterator
import Index
import Tagged
public import Store
import Span
import Ownership
import Cardinal
import Ordinal
import Property
import Carrier
import Difference
import Storage

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

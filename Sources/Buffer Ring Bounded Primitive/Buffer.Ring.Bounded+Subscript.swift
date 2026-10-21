import Cardinal
import Carrier
import Difference
public import Index
import Iterator
public import Ordinal
import Ownership
import Property
import Sequence
import Span
public import Store
public import Tagged

extension Buffer.Ring.Bounded where S: ~Copyable {

    @inlinable
    public subscript(index: Index<S.Element>) -> S.Element {
        _read {
            let physical = Index.Modular.physical(
                forLogical: index,
                head: header.head,
                capacity: header.capacity
            )
            yield storage[physical]
        }
        _modify {
            let physical = Index.Modular.physical(
                forLogical: index,
                head: header.head,
                capacity: header.capacity
            )
            yield &storage[physical]
        }
    }
}

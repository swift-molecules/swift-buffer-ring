import Sequence
import Iterator
public import Index
public import Tagged
public import Store
import Span
import Ownership
import Cardinal
import Ordinal
import Property
import Tagged
import Carrier
public import Ordinal
import Difference

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

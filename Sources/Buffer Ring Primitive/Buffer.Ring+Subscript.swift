import Sequence
import Iterator
public import Index
public import Tagged
public import Store
import Span
import Ownership
import Ordinal_Tagged
import Ordinal_Cardinal
public import Ordinal
import Cardinal_Tagged
import Cardinal
import Difference
public import Ordinal

extension Buffer.Ring where S: ~Copyable {

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

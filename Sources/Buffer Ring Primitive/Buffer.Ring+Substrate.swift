public import Sequence
public import Iterator
public import Index
public import Tagged
public import Store
public import Span
public import Ownership
public import Ordinal_Tagged
public import Ordinal_Cardinal
public import Ordinal
public import Cardinal_Tagged
public import Cardinal
import Storage

extension Buffer.Ring where S: ~Copyable {

    @inlinable
    public var substrate: S {
        _read { yield storage }
    }
}

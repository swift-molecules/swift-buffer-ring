import Sequence
import Iterator
import Store
import Span
import Ownership
import Ordinal_Tagged
import Ordinal_Cardinal
import Cardinal_Tagged
import Difference
public import Cardinal
public import Index
public import Memory_Allocator
public import Memory_Allocator_Protocol
public import Ordinal
public import Ordinal
public import Storage_Memory
public import Tagged

extension Buffer.Ring where S: ~Copyable {

    @inlinable
    public func clone<Element, Resource: Memory.Growable & ~Copyable>() -> Self
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<Element>, Element: Copyable {
        var fresh = S.create(minimumCapacity: header.capacity)
        var slot: Index<Element> = .zero
        let end = header.count.map { Ordinal($0.rawValue) }
        while slot < end {
            fresh.initialize(at: slot, to: self[slot])
            slot = (slot + .one)
        }
        var copy = Self(header: Header(capacity: fresh.capacity), storage: fresh)
        copy.header.count = header.count
        copy.storage.initialization = .init(copy.header)
        return copy
    }
}

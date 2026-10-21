public import Cardinal
import Carrier
import Difference
public import Index
import Iterator
public import Memory_Allocator
public import Memory_Allocator_Protocol
public import Ordinal
import Ownership
import Property
import Sequence
import Span
public import Storage
import Store
public import Tagged

extension Buffer.Ring.Bounded where S: ~Copyable {

    @inlinable
    public func clone<Element, Resource: Memory.Growable & ~Copyable>() -> Self
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<Element>, Element: Copyable {
        var fresh = S.create(minimumCapacity: header.capacity)
        var slot: Index<Element> = .zero
        let end = header.count.map { Ordinal($0.rawValue) }
        while slot < end {
            fresh.initialize(at: slot, to: self[slot])
            slot = (slot + Tagged<Element, Cardinal>.one)
        }
        var copy = Self(header: Buffer.Ring.Header(capacity: fresh.capacity), storage: fresh)
        copy.header.count = header.count
        copy.storage.initialization = .init(copy.header)
        return copy
    }
}

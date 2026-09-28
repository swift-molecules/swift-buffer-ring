import Sequence
import Iterator
import Store
import Span
import Ownership
import Cardinal
import Ordinal
import Property
import Tagged
import Carrier
import Difference
public import Cardinal
public import Index
public import Memory_Allocator
public import Memory_Allocator_Protocol
public import Ordinal
public import Storage
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

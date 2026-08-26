import Affine_Standard_Library_Integration
public import Index
public import Memory_Allocator_Primitive
public import Memory_Allocator_Protocol
import Ordinal_Standard_Library_Integration
public import Storage_Contiguous

extension Buffer.Ring.Bounded where S: ~Copyable {

    @inlinable
    public func clone<Element, Resource: Memory.Growable & ~Copyable>() -> Self
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<Element>, Element: Copyable {
        var fresh = S.create(minimumCapacity: header.capacity)
        var slot: Index<Element> = .zero
        let end = header.count.map(Ordinal.init)
        while slot < end {
            fresh.initialize(at: slot, to: self[slot])
            slot = slot.successor.saturating()
        }
        var copy = Self(header: Buffer.Ring.Header(capacity: fresh.capacity), storage: fresh)
        copy.header.count = header.count
        copy.storage.initialization = .init(copy.header)
        return copy
    }
}

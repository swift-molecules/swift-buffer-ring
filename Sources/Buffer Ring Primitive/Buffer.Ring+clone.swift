public import Sequence_Protocol
public import Iterator_Chunk
public import Iterable
public import Store_Ledgered
public import Store_Initialization
public import Store_Operations
public import Store_Protocol
public import Store
public import Span_Protocol
public import Ownership_Inout
public import Ownership_Borrow
public import Ordinal_Tagged
public import Ordinal_Protocol
public import Ordinal_Cardinal
public import Cardinal_Tagged
public import Cardinal_Carrier
public import Affine_Standard_Library_Integration
public import Cardinal
public import Index
public import Memory_Allocator
public import Memory_Allocator_Protocol
public import Ordinal_Standard_Library_Integration
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

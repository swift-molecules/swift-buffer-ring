public import Buffer_Ring
import Memory_Heap
public import Storage_Contiguous
import Storage_Protocol

extension Buffer.Ring where S: Store.`Protocol`, S: ~Copyable {

    @inlinable
    public init<E>(
        _ elements: [E],
        minimumCapacity: UInt = 0
    ) where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
        let cap: Index<E>.Count = .init(Cardinal(Swift.max(UInt(elements.count), minimumCapacity)))
        var buffer = Self(minimumCapacity: cap)
        for element in elements {
            buffer.push.back(element)
        }
        self = buffer
    }
}

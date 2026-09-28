public import Index
public import Cardinal
public import Carrier
public import Ordinal
public import Tagged
public import Property
public import Store
public import Memory_Small
public import Buffer_Ring
import Memory
public import Storage
import Storage

extension Buffer.Ring where S: Store.`Protocol`, S: ~Copyable {

    @inlinable
    public init<E>(
        _ elements: [E],
        minimumCapacity: UInt = 0
    ) where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
        let cap: Tagged<E, Cardinal> = .init(
            _unchecked: Cardinal(Swift.max(UInt(elements.count), minimumCapacity))
        )
        var buffer = Self(minimumCapacity: cap)
        for element in elements {
            buffer.push.back(element)
        }
        self = buffer
    }
}

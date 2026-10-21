public import Buffer_Ring
public import Cardinal
import Carrier
import Index
import Memory
public import Memory_Small
import Ordinal
import Property
public import Storage
public import Store
public import Tagged

extension Buffer.Ring where S: Store.`Protocol`, S: ~Copyable {

    @inlinable
    public init<E>(
        _ elements: [E],
        minimumCapacity: UInt = 0
    ) where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
        let cap: Tagged<E, Cardinal> = .init(
            _unchecked: Cardinal(Swift::max(UInt(elements.count), minimumCapacity))
        )
        var buffer = Self(minimumCapacity: cap)
        for element in elements {
            buffer.push.back(element)
        }
        self = buffer
    }
}

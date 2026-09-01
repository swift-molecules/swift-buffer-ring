public import Index
public import Ordinal_Cardinal
public import Ordinal_Tagged
public import Ordinal
public import Cardinal_Tagged
public import Cardinal_Carrier
public import Store_Ledgered
public import Store_Operations
public import Store_Initialization
public import Store_Protocol
public import Store
public import Tagged
public import Cardinal
public import Memory_Small
public import Buffer_Ring
import Memory
public import Storage_Memory
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

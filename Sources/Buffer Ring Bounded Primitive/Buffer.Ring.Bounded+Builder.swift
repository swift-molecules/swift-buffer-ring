public import Memory
import Sequence
import Iterator
import Index
import Store
import Span
import Ownership
import Cardinal
import Ordinal
import Property
import Tagged
import Carrier
public import Tagged
public import Cardinal
public import Memory_Small
import Difference
public import Buffer
public import Memory_Allocator_Protocol

extension Buffer.Ring.Bounded where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        minimumCapacity: Tagged<E, Cardinal>,
        @Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring.Builder _ builder: () ->
            Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring
    ) throws(Self.Error) where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
        var dynamic = builder()
        guard dynamic.count <= minimumCapacity else {
            throw .capacityExceeded
        }
        self.init(minimumCapacity: minimumCapacity)
        while !dynamic.isEmpty {
            _ = self.push.back(dynamic.pop.front())
        }
    }
}

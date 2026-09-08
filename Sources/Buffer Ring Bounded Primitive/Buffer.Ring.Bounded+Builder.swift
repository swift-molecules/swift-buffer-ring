public import Sequence
public import Iterator
public import Index
public import Store
public import Span
public import Ownership
public import Ordinal_Tagged
public import Ordinal_Cardinal
public import Ordinal
public import Cardinal_Tagged
public import Tagged
public import Cardinal
public import Memory_Small
public import Difference
public import Buffer
public import Ordinal

extension Buffer.Ring.Bounded where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable>(
        minimumCapacity: Tagged<E, Cardinal>,
        @Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Ring.Builder _ builder: () ->
            Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Ring
    ) throws(Self.Error) where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
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

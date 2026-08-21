import Affine_Primitives_Standard_Library_Integration
public import Buffer_Protocol_Primitives
import Ordinal_Primitives_Standard_Library_Integration

extension Buffer.Ring.Bounded where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable>(
        minimumCapacity: Index<E>.Count,
        @Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring.Builder _ builder: () ->
            Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring
    ) throws(Self.Error) where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
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

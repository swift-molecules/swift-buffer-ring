public import Sequence_Protocol
public import Iterator_Chunk
public import Iterable
public import Index
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
public import Ordinal
public import Cardinal_Tagged
public import Cardinal_Carrier
public import Tagged
public import Cardinal
public import Memory_Small
public import Affine_Standard_Library_Integration
public import Buffer
public import Ordinal_Standard_Library_Integration

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

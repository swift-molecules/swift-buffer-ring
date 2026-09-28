import Buffer_Ring
import Buffer_Ring_Bounded
import Buffer
import Storage
import Memory_Allocator
import Memory
import Index
import Testing

@Suite
struct CanonicalContainerIntegrationTests {
    @Test
    func `Ring spells the cyclic column; the bounded ring chains through the alias`() throws {
            var r = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Ring(minimumCapacity: 4)
            r.push.back(1)
            r.push.back(2)
            #expect(r.count == 2)
            let b = try Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Ring.Bounded([10, 20], capacity: 4)
            #expect(b.count == 2)
        }
}

import Buffer_Ring_Primitives
import Memory_Allocator_Primitive
import Memory_Small_Primitives
import Storage_Contiguous_Primitives
import Testing

@Suite
struct `Buffer.Ring.Small Tests` {

    typealias SmallColumn = Storage<Memory.Allocator<Memory.Small<64>>>.Contiguous<Int>
}

extension `Buffer.Ring.Small Tests` {

    @Test
    func `construct + enqueue (form-2, inline→heap spill) + drain via popFront (form-1)`() {

        var ring = Buffer<SmallColumn>.Ring(minimumCapacity: 4)

        for value in 1...16 {
            ring.pushBack(value)
        }
        #expect(ring.count == 16)

        var expected = 1
        while ring.count > .zero {
            let element = ring.popFront()
            #expect(element == expected)
            expected += 1
        }
        #expect(expected == 17)
    }

    @Test
    func `consuming .drain (form-1) over Memory.Small<64>`() {
        var ring = Buffer<SmallColumn>.Ring(minimumCapacity: 2)
        ring.pushBack(100)
        ring.pushBack(200)
        ring.pushBack(300)
        #expect(ring.count == 3)

        var seen: [Int] = []
        ring.drain { seen.append($0) }
        #expect(seen == [100, 200, 300])
        #expect(ring.count == .zero)
    }

    @Test
    func `static seam ops (form-1) over a Memory.Small<64> substrate`() {
        let capacity: Index<Int>.Count = 8
        var header = Buffer<SmallColumn>.Ring.Header(capacity: capacity)
        var storage = SmallColumn.create(minimumCapacity: capacity)

        Buffer<SmallColumn>.Ring.pushBack(1, header: &header, storage: &storage)
        Buffer<SmallColumn>.Ring.pushBack(2, header: &header, storage: &storage)
        #expect(header.count == 2)

        let first = Buffer<SmallColumn>.Ring.popFront(header: &header, storage: &storage)
        #expect(first == 1)

        Buffer<SmallColumn>.Ring.deinitializeAll(header: &header, storage: &storage)
        let headerIsEmpty = header.isEmpty
        #expect(headerIsEmpty)

        storage.initialization = .empty
    }
}

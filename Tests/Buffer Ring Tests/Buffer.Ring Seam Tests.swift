import Ordinal_Cardinal
import Ordinal_Tagged
import Cardinal_Tagged
import Cardinal_Carrier
import Store_Ledgered
import Store_Operations
import Store_Initialization
import Store_Protocol
import Store
import Tagged
import Cardinal
import Cardinal_Standard_Library_Integration
import Ordinal_Standard_Library_Integration
import Tagged_Standard_Library_Integration
import Memory_Small
import Buffer_Ring
import Buffer_Ring_Test_Support
import Index
import Memory_Allocator
import Memory
import Ordinal
import Storage_Memory
import Testing

private typealias HeapStorage<E: ~Copyable> =
    Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>

private typealias GrowableRing<E: ~Copyable> = Buffer<HeapStorage<E>>.Ring
private typealias BoundedRing<E: ~Copyable> = Buffer<HeapStorage<E>>.Ring.Bounded

@Suite
struct RingSeamLawTests {

    @Test
    func `the growable ring preserves FIFO order through its public seam`() {
        var ring = GrowableRing<Int>(minimumCapacity: 4)
        ring.push.back(1)
        ring.push.back(2)
        ring.push.back(3)
        #expect(ring.pop.front() == 1)
        #expect(ring.pop.front() == 2)
        #expect(ring.pop.front() == 3)
        let isEmpty = ring.isEmpty
        #expect(isEmpty)
    }

    @Test
    func `the bounded ring rejects overflow through its public seam`() {
        var ring = BoundedRing<Int>(minimumCapacity: 2)
        #expect(ring.push.back(1) == nil)
        #expect(ring.push.back(2) == nil)
        #expect(ring.push.back(3) == 3)
        #expect(ring.pop.front() == 1)
        #expect(ring.pop.front() == 2)
    }
}

@Suite
struct RingSeamDisciplineTests {

    @Test
    func `FIFO order survives a physical wrap driven purely through seam ops`() {
        var ring = GrowableRing<Int>(minimumCapacity: Tagged<Int, Cardinal>(4))
        ring.initialize(at: 0, to: 1)
        ring.initialize(at: 1, to: 2)
        ring.initialize(at: 2, to: 3)
        ring.initialize(at: 3, to: 4)
        let a = ring.move(at: 0)
        let b = ring.move(at: 0)
        #expect(a == 1)
        #expect(b == 2)
        ring.initialize(at: 2, to: 5)
        ring.initialize(at: 3, to: 6)
        var seen: [Int] = []
        while !ring.isEmpty {
            seen.append(ring.move(at: 0))
        }
        #expect(seen == [3, 4, 5, 6])
    }

    @Test
    func `the logical subscript re-anchors after a front move`() {
        var ring = GrowableRing<Int>(minimumCapacity: Tagged<Int, Cardinal>(4))
        ring.initialize(at: 0, to: 10)
        ring.initialize(at: 1, to: 20)
        ring.initialize(at: 2, to: 30)
        _ = ring.move(at: 0)
        let front = ring[0]
        #expect(front == 20)
        ring[1] = 33
        let e1 = ring[1]
        #expect(e1 == 33)
        let n = ring.count
        #expect(n == Tagged<Int, Cardinal>(2))
    }

    @Test
    func `back moves retreat the tail without touching the head`() {
        var ring = GrowableRing<Int>(minimumCapacity: Tagged<Int, Cardinal>(3))
        ring.initialize(at: 0, to: 1)
        ring.initialize(at: 1, to: 2)
        ring.initialize(at: 2, to: 3)
        let back = ring.move(at: 2)
        #expect(back == 3)
        let front = ring[0]
        #expect(front == 1)
        let n = ring.count
        #expect(n == Tagged<Int, Cardinal>(2))
    }

    @Test
    func `the bounded ring rides the same seam discipline`() {
        var ring = BoundedRing<Int>(minimumCapacity: Tagged<Int, Cardinal>(3))
        ring.initialize(at: 0, to: 7)
        ring.initialize(at: 1, to: 8)
        _ = ring.move(at: 0)
        ring.initialize(at: 1, to: 9)
        var seen: [Int] = []
        while !ring.isEmpty {
            seen.append(ring.move(at: 0))
        }
        #expect(seen == [8, 9])
    }
}

@Suite(.serialized)
struct RingSeamTeardownTests {

    @Test
    func `dropping a WRAPPED ring destroys exactly the live elements`() {
        SeamProbe.reset()
        do {
            var ring = GrowableRing<SeamItem>(minimumCapacity: Tagged<SeamItem, Cardinal>(4))
            ring.initialize(at: Index<SeamItem>(_unchecked: Ordinal(UInt(0))), to: SeamItem(1))
            ring.initialize(at: Index<SeamItem>(_unchecked: Ordinal(UInt(1))), to: SeamItem(2))
            ring.initialize(at: Index<SeamItem>(_unchecked: Ordinal(UInt(2))), to: SeamItem(3))
            ring.initialize(at: Index<SeamItem>(_unchecked: Ordinal(UInt(3))), to: SeamItem(4))
            _ = ring.move(at: Index<SeamItem>(_unchecked: Ordinal(UInt(0))))
            _ = ring.move(at: Index<SeamItem>(_unchecked: Ordinal(UInt(0))))
            ring.initialize(at: Index<SeamItem>(_unchecked: Ordinal(UInt(2))), to: SeamItem(5))
            ring.initialize(at: Index<SeamItem>(_unchecked: Ordinal(UInt(3))), to: SeamItem(6))
            let mid = SeamProbe.destroyedSorted
            #expect(mid == [1, 2])
        }
        let all = SeamProbe.destroyedSorted
        #expect(all == [1, 2, 3, 4, 5, 6])
    }
}

private struct SeamItem: ~Copyable {
    let id: Int
    init(_ id: Int) { self.id = id }
    deinit { SeamProbe.recordDestroy(id) }
}

private enum SeamProbe {}

extension SeamProbe {
    nonisolated(unsafe) static var _destroyed: [Int] = []
    static func reset() { unsafe _destroyed = [] }
    static func recordDestroy(_ id: Int) { unsafe _destroyed.append(id) }
    static var destroyedSorted: [Int] { unsafe _destroyed.sorted() }
}

@Suite
struct RingCloneTests {

    @Test
    func `cloning a WRAPPED ring preserves logical order and detaches storage`() {
        var ring = GrowableRing<Int>(minimumCapacity: Tagged<Int, Cardinal>(4))
        ring.initialize(at: 0, to: 1)
        ring.initialize(at: 1, to: 2)
        ring.initialize(at: 2, to: 3)
        ring.initialize(at: 3, to: 4)
        _ = ring.move(at: 0)
        _ = ring.move(at: 0)
        ring.initialize(at: 2, to: 5)
        var copy = ring.clone()
        let copyCount = copy.count
        #expect(copyCount == Tagged<Int, Cardinal>(3))
        copy[0] = 300
        let mine = ring[0]
        let theirs = copy[0]
        #expect(mine == 3)
        #expect(theirs == 300)
        var seen: [Int] = []
        while !copy.isEmpty {
            seen.append(copy.move(at: 0))
        }
        #expect(seen == [300, 4, 5])
    }

    @Test
    func `cloning a bounded ring preserves the fixed capacity`() {
        var ring = BoundedRing<Int>(minimumCapacity: Tagged<Int, Cardinal>(3))
        ring.initialize(at: 0, to: 7)
        ring.initialize(at: 1, to: 8)
        let copy = ring.clone()
        let cap = copy.capacity
        let n = copy.count
        #expect(cap == ring.capacity)
        #expect(n == Tagged<Int, Cardinal>(2))
        let front = copy[0]
        #expect(front == 7)
    }
}

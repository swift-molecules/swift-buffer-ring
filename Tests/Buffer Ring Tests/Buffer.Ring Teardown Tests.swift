import Buffer_Ring
import Buffer_Ring_Test_Support
import Cardinal
import Carrier
import Index
import Memory
import Memory_Small
import Ordinal
import Property
import Sequence
import Storage
import Store
import Tagged
import Testing

private final class Tally: @unchecked Sendable {
    var destroyed: [Int] = []
}

private struct Tracked: ~Copyable {
    let id: Int
    let tally: Tally

    deinit { tally.destroyed.append(id) }
}

private typealias Ring = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Tracked>>.Ring
private typealias BoundedRing = Ring.Bounded
private typealias IntRing = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring
private typealias IntBoundedRing = IntRing.Bounded

/// Fills a ring so that its live range wraps the physical end: fills it, pops
/// two from the front, then fills it again. Returns the ids still in the ring.
private func wrap(_ ring: inout Ring, tally: Tally) -> [Int] {
    let capacity = Int(ring.capacity.underlying.rawValue)
    var next = 0
    while next < capacity {
        ring.push.back(Tracked(id: next, tally: tally))
        next += 1
    }
    _ = ring.pop.front()
    _ = ring.pop.front()
    while !ring.isFull {
        ring.push.back(Tracked(id: next, tally: tally))
        next += 1
    }
    return Array(2..<next)
}

private func wrap(_ ring: inout BoundedRing, tally: Tally) -> [Int] {
    let capacity = Int(ring.capacity.underlying.rawValue)
    var next = 0
    while next < capacity {
        _ = ring.push.back(Tracked(id: next, tally: tally))
        next += 1
    }
    _ = ring.pop.front()
    _ = ring.pop.front()
    while !ring.isFull {
        _ = ring.push.back(Tracked(id: next, tally: tally))
        next += 1
    }
    return Array(2..<next)
}

@Suite
struct `Buffer.Ring Teardown Tests` {

    @Test
    func `draining a wrapped ring destroys each element exactly once`() {
        let tally = Tally()
        var live: [Int] = []
        do {
            var ring = Ring(minimumCapacity: 4)
            live = wrap(&ring, tally: tally)
            var drained: [Int] = []
            ring.drain { element in drained.append(element.id) }
            #expect(drained == live)
        }
        #expect(tally.destroyed.sorted() == Array(0..<(live.count + 2)))
    }

    @Test
    func `draining a wrapped bounded ring destroys each element exactly once`() {
        let tally = Tally()
        var live: [Int] = []
        do {
            var ring = BoundedRing(minimumCapacity: 4)
            live = wrap(&ring, tally: tally)
            var drained: [Int] = []
            ring.drain { element in drained.append(element.id) }
            #expect(drained == live)
        }
        #expect(tally.destroyed.sorted() == Array(0..<(live.count + 2)))
    }

    @Test
    func `growing a wrapped ring destroys each element exactly once`() {
        let tally = Tally()
        var total = 0
        do {
            var ring = Ring(minimumCapacity: 4)
            var live = wrap(&ring, tally: tally)
            total = live.count + 2
            ring.push.back(Tracked(id: total, tally: tally))
            live.append(total)
            total += 1
            #expect(ring.count.underlying.rawValue == UInt(live.count))
            var order: [Int] = []
            ring.forEach { order.append($0.id) }
            #expect(order == live)
        }
        #expect(tally.destroyed.sorted() == Array(0..<total))
    }

    @Test
    func `restore destroys the elements pushed since the checkpoint`() {
        let tally = Tally()
        do {
            var ring = Ring(minimumCapacity: 8)
            ring.push.back(Tracked(id: 0, tally: tally))
            ring.push.back(Tracked(id: 1, tally: tally))
            let checkpoint = ring.checkpoint
            ring.push.back(Tracked(id: 2, tally: tally))
            ring.push.back(Tracked(id: 3, tally: tally))
            ring.restore(to: checkpoint)
            #expect(tally.destroyed.sorted() == [2, 3])
            #expect(ring.count.underlying.rawValue == 2)
        }
        #expect(tally.destroyed.sorted() == [0, 1, 2, 3])
    }

    @Test
    func `bounded restore destroys the elements pushed since the checkpoint`() {
        let tally = Tally()
        do {
            var ring = BoundedRing(minimumCapacity: 8)
            _ = ring.push.back(Tracked(id: 0, tally: tally))
            let checkpoint = ring.checkpoint
            _ = ring.push.back(Tracked(id: 1, tally: tally))
            _ = ring.push.back(Tracked(id: 2, tally: tally))
            ring.restore(to: checkpoint)
            #expect(tally.destroyed.sorted() == [1, 2])
            #expect(ring.count.underlying.rawValue == 1)
        }
        #expect(tally.destroyed.sorted() == [0, 1, 2])
    }
}

@Suite
struct `Buffer.Ring Precondition Tests` {

    @Test
    func `restore after the front was popped traps`() async {
        await #expect(processExitsWith: .failure) {
            var ring = IntRing(minimumCapacity: 8)
            ring.push.back(1)
            ring.push.back(2)
            let checkpoint = ring.checkpoint
            _ = ring.pop.front()
            ring.restore(to: checkpoint)
        }
    }

    @Test
    func `restore after growth traps`() async {
        await #expect(processExitsWith: .failure) {
            var ring = IntRing(minimumCapacity: 1)
            let checkpoint = ring.checkpoint
            ring.reserveCapacity(64)
            ring.restore(to: checkpoint)
        }
    }

    @Test
    func `pop front on an empty ring traps`() async {
        await #expect(processExitsWith: .failure) {
            var ring = IntRing(minimumCapacity: 4)
            _ = ring.pop.front()
        }
    }

    @Test
    func `pop back on an empty bounded ring traps`() async {
        await #expect(processExitsWith: .failure) {
            var ring = IntBoundedRing(minimumCapacity: 4)
            _ = ring.pop.back()
        }
    }

    @Test
    func `peek front on an empty ring traps`() async {
        await #expect(processExitsWith: .failure) {
            let ring = IntRing(minimumCapacity: 4)
            _ = ring.peek.front
        }
    }

    @Test
    func `peek back on an empty bounded ring traps`() async {
        await #expect(processExitsWith: .failure) {
            let ring = IntBoundedRing(minimumCapacity: 4)
            _ = ring.peek.back
        }
    }

    @Test
    func `withFront on an empty ring traps`() async {
        await #expect(processExitsWith: .failure) {
            let ring = IntRing(minimumCapacity: 4)
            _ = ring.withFront { $0 }
        }
    }

    @Test
    func `withBack on an empty bounded ring traps`() async {
        await #expect(processExitsWith: .failure) {
            let ring = IntBoundedRing(minimumCapacity: 4)
            _ = ring.withBack { $0 }
        }
    }

    @Test
    func `subscript at count traps`() async {
        await #expect(processExitsWith: .failure) {
            var ring = IntRing(minimumCapacity: 4)
            ring.push.back(1)
            _ = ring[Index<Int>(_unchecked: Ordinal(1))]
        }
    }

    @Test
    func `bounded subscript at count traps`() async {
        await #expect(processExitsWith: .failure) {
            var ring = IntBoundedRing(minimumCapacity: 4)
            _ = ring.push.back(1)
            _ = ring[Index<Int>(_unchecked: Ordinal(1))]
        }
    }
}

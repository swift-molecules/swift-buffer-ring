import Tagged
import Cardinal
import Cardinal_Standard_Library_Integration
import Ordinal_Standard_Library_Integration
import Tagged_Standard_Library_Integration
import Memory_Small
import Buffer_Ring
import Buffer_Ring_Test_Support
import Memory
import Storage_Memory
import Testing

@Suite
struct `Buffer.Ring Tests` {
    @Suite struct Unit {}
    @Suite struct EdgeCase {}
    @Suite struct Integration {}
}

extension `Buffer.Ring Tests`.Unit {

    @Test
    func `FIFO ordering`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring(
            minimumCapacity: 4
        )
        buffer.push.back(10)
        buffer.push.back(20)
        buffer.push.back(30)

        #expect(buffer.count.underlying.rawValue == 3)

        #expect(buffer.pop.front() == 10)
        #expect(buffer.pop.front() == 20)
        #expect(buffer.pop.front() == 30)
        let bufferIsEmpty = buffer.isEmpty
        #expect(bufferIsEmpty)
    }

    @Test
    func `wrap-around behavior`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring(
            minimumCapacity: 4
        )

        let cap = buffer.capacity.underlying.rawValue
        var i: UInt = 0
        while i < cap {
            buffer.push.back(Int(i))
            i += 1
        }
        let bufferIsFull = buffer.isFull
        #expect(bufferIsFull)

        _ = buffer.pop.front()
        _ = buffer.pop.front()
        buffer.push.back(100)
        buffer.push.back(200)

        #expect(buffer.pop.front() == 2)
        #expect(buffer.pop.front() == 3)
    }

    @Test
    func `growth doubles capacity`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring(
            minimumCapacity: 2
        )
        let originalCap = buffer.capacity

        var i = 0
        let needed = Int(originalCap.underlying.rawValue) + 1
        while i < needed {
            buffer.push.back(i * 10)
            i += 1
        }

        #expect(buffer.capacity.underlying.rawValue > originalCap.underlying.rawValue)

        i = 0
        while i < needed {
            #expect(buffer.pop.front() == i * 10)
            i += 1
        }
    }

    @Test
    func `slotCapacity invariant — capacity from storage, not request`() {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring(
            minimumCapacity: 3
        )

        #expect(buffer.capacity.underlying.rawValue >= 3)
    }

    @Test
    func `drain removes all elements in FIFO order`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring([
            10, 20, 30,
        ])
        var drained: [Int] = []
        buffer.drain { drained.append($0) }
        #expect(drained == [10, 20, 30])
        let bufferIsEmpty = buffer.isEmpty
        #expect(bufferIsEmpty)
    }

    @Test
    func `removeAll clears buffer`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring([1, 2, 3])
        buffer.remove.all()
        let bufferIsEmpty = buffer.isEmpty
        #expect(bufferIsEmpty)
        #expect(buffer.count.underlying.rawValue == 0)
    }

    @Test
    func `reserveCapacity grows if needed`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring(
            minimumCapacity: 2
        )
        buffer.reserveCapacity(.init(_unchecked: Cardinal(UInt(100))))
        #expect(buffer.capacity.underlying.rawValue >= 100)
    }

    @Test
    func `peekFront and peekBack (Copyable)`() {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring([
            10, 20, 30,
        ])

        let bufferPeekFront = buffer.peek.front
        #expect(bufferPeekFront == 10)
        let bufferPeekBack = buffer.peek.back
        #expect(bufferPeekBack == 30)
    }

    @Test
    func `pushFront and popBack (deque behavior)`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring(
            minimumCapacity: 4
        )
        buffer.push.front(10)
        buffer.push.front(20)

        #expect(buffer.pop.back() == 10)
        #expect(buffer.pop.back() == 20)
    }

    @Test
    func `Iterator iteration (Copyable)`() {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring([
            10, 20, 30,
        ])

        var collected: [Int] = []
        buffer.forEach { collected.append($0) }
        #expect(collected == [10, 20, 30])
    }

    @Test
    func `single element`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring(
            minimumCapacity: 1
        )
        buffer.push.back(42)
        #expect(buffer.count.underlying.rawValue == 1)
        #expect(buffer.pop.front() == 42)
        let bufferIsEmpty = buffer.isEmpty
        #expect(bufferIsEmpty)
    }

    @Test
    func `withFront borrows first element`() {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring([
            10, 20, 30,
        ])
        let value = buffer.withFront { $0 }
        #expect(value == 10)
        #expect(buffer.count.underlying.rawValue == 3)
    }

    @Test
    func `withBack borrows last element`() {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring([
            10, 20, 30,
        ])
        let value = buffer.withBack { $0 }
        #expect(value == 30)
        #expect(buffer.count.underlying.rawValue == 3)
    }

    @Test
    func `forEach visits all elements in FIFO order`() {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring([
            10, 20, 30,
        ])
        var visited: [Int] = []
        buffer.forEach { visited.append($0) }
        #expect(visited == [10, 20, 30])
    }

    @Test
    func `checkpoint saves current position`() {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring([
            10, 20, 30,
        ])
        let cp = buffer.checkpoint
        #expect(cp.count.underlying.rawValue == 3)
    }

    @Test
    func `compact reclaims unused capacity`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring(
            minimumCapacity: 100
        )
        buffer.push.back(1)
        buffer.push.back(2)
        buffer.compact()
        #expect(buffer.capacity.underlying.rawValue <= 4)
        #expect(buffer.pop.front() == 1)
        #expect(buffer.pop.front() == 2)
    }

    @Test
    func `array initialization records the logical count`() {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring([
            10, 20, 30,
        ])
        #expect(buffer.count.underlying.rawValue == 3)
    }
}

extension `Buffer.Ring Tests`.EdgeCase {

    @Test
    func `empty buffer operations`() {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring(
            minimumCapacity: 4
        )
        let bufferIsEmpty = buffer.isEmpty
        #expect(bufferIsEmpty)
        #expect(buffer.count.underlying.rawValue == 0)
        let bufferIsFull = buffer.isFull
        #expect(!bufferIsFull)
    }

    @Test
    func `pushBack on empty then popFront`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring(
            minimumCapacity: 4
        )
        buffer.push.back(42)
        #expect(buffer.pop.front() == 42)
        let bufferIsEmpty = buffer.isEmpty
        #expect(bufferIsEmpty)
    }

    @Test
    func `checkpoint on empty buffer`() {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring(
            minimumCapacity: 4
        )
        let cp = buffer.checkpoint
        #expect(cp.count.underlying.rawValue == 0)
    }

    @Test
    func `reserveCapacity with zero is no-op`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring(
            minimumCapacity: 4
        )
        let originalCap = buffer.capacity
        buffer.reserveCapacity(.zero)
        #expect(buffer.capacity == originalCap)
    }

    @Test
    func `compact on already-compact buffer`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring([
            1, 2, 3, 4,
        ])
        buffer.compact()

        #expect(buffer.count.underlying.rawValue == 4)
        #expect(buffer.pop.front() == 1)
    }
}

extension `Buffer.Ring Tests`.Integration {

    @Test
    func `interleaved push/pop maintains order`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring(
            minimumCapacity: 4
        )
        buffer.push.back(1)
        buffer.push.back(2)
        #expect(buffer.pop.front() == 1)
        buffer.push.back(3)
        #expect(buffer.pop.front() == 2)
        #expect(buffer.pop.front() == 3)
        let bufferIsEmpty = buffer.isEmpty
        #expect(bufferIsEmpty)
    }

    @Test
    func `checkpoint restore skips intermediate elements`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring(
            minimumCapacity: 8
        )
        buffer.push.back(10)
        buffer.push.back(20)
        let cp = buffer.checkpoint
        buffer.push.back(30)
        buffer.push.back(40)

        buffer.restore(to: cp)
        #expect(buffer.count.underlying.rawValue == 2)
        #expect(buffer.pop.front() == 10)
        #expect(buffer.pop.front() == 20)
        let bufferIsEmpty = buffer.isEmpty
        #expect(bufferIsEmpty)
    }

    @Test
    func `drain then reuse buffer`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring([
            10, 20, 30,
        ])
        buffer.drain { _ in }
        let bufferIsEmpty = buffer.isEmpty
        #expect(bufferIsEmpty)

        buffer.push.back(40)
        buffer.push.back(50)
        #expect(buffer.pop.front() == 40)
        #expect(buffer.pop.front() == 50)
    }

    @Test
    func `multipass re-iterate`() {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring([1, 2, 3])

        var first: [Int] = []
        buffer.forEach { first.append($0) }

        var collected: [Int] = []
        buffer.forEach { collected.append($0) }
        #expect(first == [1, 2, 3])
        #expect(collected == [1, 2, 3])
    }

    @Test
    func `consuming scalar over wrapped ring is FIFO`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring(
            minimumCapacity: 8
        )
        for i in 0..<8 { buffer.push.back(i) }
        for _ in 0..<5 { _ = buffer.pop.front() }
        for i in 100..<104 { buffer.push.back(i) }

        var collected: [Int] = []
        buffer.drain { collected.append($0) }
        #expect(collected == [5, 6, 7, 100, 101, 102, 103])
    }

    @Test
    func `consuming scalar with head offset, no wrap, is FIFO`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring(
            minimumCapacity: 8
        )
        for i in 0..<4 { buffer.push.back(i) }
        for _ in 0..<2 { _ = buffer.pop.front() }

        var collected: [Int] = []
        buffer.drain { collected.append($0) }
        #expect(collected == [2, 3])
    }
}

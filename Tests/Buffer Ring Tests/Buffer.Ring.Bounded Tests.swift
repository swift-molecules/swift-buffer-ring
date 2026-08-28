import Cardinal
import Cardinal_Standard_Library_Integration
import Memory_Small
import Ordinal_Standard_Library_Integration
import Buffer_Ring
import Buffer_Ring_Test_Support
import Memory
import Storage_Memory
import Tagged
import Tagged_Standard_Library_Integration
import Testing

@Suite
struct `Buffer.Ring.Bounded Tests` {
    @Suite struct Unit {}
    @Suite struct EdgeCase {}
    @Suite struct Integration {}
}

extension `Buffer.Ring.Bounded Tests`.Unit {

    @Test
    func `full rejection — pushBack returns element when full`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring.Bounded(
            minimumCapacity: 2
        )
        let cap = buffer.capacity.underlying.rawValue

        var i: UInt = 0
        while i < cap {
            let rejected = buffer.push.back(Int(i))
            #expect(rejected == nil)
            i += 1
        }
        let bufferIsFull = buffer.isFull
        #expect(bufferIsFull)

        let rejected = buffer.push.back(999)
        #expect(rejected == 999)
    }

    @Test
    func `full rejection — pushFront returns element when full`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring.Bounded(
            minimumCapacity: 2
        )
        let cap = buffer.capacity.underlying.rawValue

        var i: UInt = 0
        while i < cap {
            _ = buffer.push.back(Int(i))
            i += 1
        }

        let rejected = buffer.push.front(999)
        #expect(rejected == 999)
    }

    @Test
    func `peekFront and peekBack (Copyable)`() throws {
        let buffer = try Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring
            .Bounded([10, 20, 30], capacity: 4)

        let bufferPeekFront = buffer.peek.front
        #expect(bufferPeekFront == 10)
        let bufferPeekBack = buffer.peek.back
        #expect(bufferPeekBack == 30)
    }

    @Test
    func `removeAll clears buffer`() throws {
        var buffer = try Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring
            .Bounded([1, 2, 3], capacity: 4)
        buffer.remove.all()
        let bufferIsEmpty = buffer.isEmpty
        #expect(bufferIsEmpty)
    }

    @Test
    func `Iterator iteration (Copyable)`() throws {
        let buffer = try Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring
            .Bounded([10, 20, 30], capacity: 4)

        var collected: [Int] = []
        buffer.forEach { collected.append($0) }
        #expect(collected == [10, 20, 30])
    }

    @Test
    func `checkpoint and restore`() throws {
        var buffer = try Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring
            .Bounded([10, 20], capacity: 8)
        let cp = buffer.checkpoint
        _ = buffer.push.back(30)
        _ = buffer.push.back(40)

        buffer.restore(to: cp)
        #expect(buffer.count.underlying.rawValue == 2)
        #expect(buffer.pop.front() == 10)
        #expect(buffer.pop.front() == 20)
    }
}

extension `Buffer.Ring.Bounded Tests`.EdgeCase {

    @Test
    func `capacity-of-1 ring`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring.Bounded(
            minimumCapacity: 1
        )
        let rejected = buffer.push.back(42)
        #expect(rejected == nil)
        let bufferIsFull = buffer.isFull
        #expect(bufferIsFull)

        let value = buffer.pop.front()
        #expect(value == 42)
        let bufferIsEmpty = buffer.isEmpty
        #expect(bufferIsEmpty)
    }

    @Test
    func `full buffer pushFront evicts nothing — returns element`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring.Bounded(
            minimumCapacity: 2
        )
        let cap = buffer.capacity.underlying.rawValue
        var i: UInt = 0
        while i < cap {
            _ = buffer.push.back(Int(i))
            i += 1
        }

        let rejected = buffer.push.front(999)
        #expect(rejected == 999)

        let bufferPeekFront = buffer.peek.front
        #expect(bufferPeekFront == 0)
    }

    @Test
    func `restore after wrapping`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring.Bounded(
            minimumCapacity: 4
        )
        _ = buffer.push.back(1)
        _ = buffer.push.back(2)
        _ = buffer.push.back(3)
        _ = buffer.pop.front()
        _ = buffer.pop.front()
        let cp = buffer.checkpoint
        _ = buffer.push.back(4)
        _ = buffer.push.back(5)

        buffer.restore(to: cp)
        #expect(buffer.count.underlying.rawValue == 1)
        #expect(buffer.pop.front() == 3)
    }
}

extension `Buffer.Ring.Bounded Tests`.Integration {

    @Test
    func `interleaved push/pop cycles`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring.Bounded(
            minimumCapacity: 3
        )
        _ = buffer.push.back(1)
        _ = buffer.push.back(2)
        #expect(buffer.pop.front() == 1)
        _ = buffer.push.back(3)
        #expect(buffer.pop.front() == 2)
        _ = buffer.push.back(4)
        #expect(buffer.pop.front() == 3)
        #expect(buffer.pop.front() == 4)
        let bufferIsEmpty = buffer.isEmpty
        #expect(bufferIsEmpty)
    }

    @Test
    func `fill/drain cycle`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring.Bounded(
            minimumCapacity: 4
        )
        let cap = Int(buffer.capacity.underlying.rawValue)

        var i = 0
        while i < cap {
            _ = buffer.push.back(i)
            i += 1
        }
        let bufferIsFull = buffer.isFull
        #expect(bufferIsFull)

        var drained: [Int] = []
        buffer.drain { drained.append($0) }
        let bufferIsEmpty = buffer.isEmpty
        #expect(bufferIsEmpty)
        #expect(drained.count == cap)
    }
}

extension `Buffer.Ring.Bounded Tests`.Unit {
    @Test
    func
        `peek front and back return stable values across repeated reads (finding #12 regression guard)`()
    {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring.Bounded(
            minimumCapacity: 4
        )
        _ = buffer.push.back(10)
        _ = buffer.push.back(20)
        _ = buffer.push.back(30)

        let front1 = buffer.peek.front
        let front2 = buffer.peek.front
        let back1 = buffer.peek.back
        let back2 = buffer.peek.back

        #expect(front1 == 10)
        #expect(front2 == 10)
        #expect(back1 == 30)
        #expect(back2 == 30)
    }
}

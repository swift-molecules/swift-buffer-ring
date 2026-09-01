import Index
import Ordinal_Cardinal
import Ordinal_Tagged
import Ordinal
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
import Memory
import Storage_Memory
import Testing

@Suite
struct `Buffer.Ring.Header Tests` {
    @Suite struct Unit {}
    @Suite struct EdgeCase {}
}

extension `Buffer.Ring.Header Tests`.Unit {

    @Test
    func `init sets head to zero, count to zero`() {
        let cap: Tagged<Int, Cardinal> = 8
        let header = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring.Header(
            capacity: cap
        )
        #expect(header.head == 0)
        #expect(header.count.underlying.rawValue == 0)
        #expect(header.capacity == cap)
    }

    @Test
    func `isEmpty and isFull`() {
        let cap: Tagged<Int, Cardinal> = 4
        var header = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring.Header(
            capacity: cap
        )
        let headerIsEmpty = header.isEmpty
        #expect(headerIsEmpty)
        let headerIsFull = header.isFull
        #expect(!headerIsFull)

        header.count = cap
        let headerIsEmpty2 = header.isEmpty
        #expect(!headerIsEmpty2)
        let headerIsFull2 = header.isFull
        #expect(headerIsFull2)
    }

    @Test
    func `initialization returns .empty when count is zero`() {
        let header = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring.Header(
            capacity: 4
        )
        switch header.initialization {
        case .empty:
            break

        default:
            Issue.record("Expected .empty initialization")
        }
    }

    @Test
    func `initialization returns .one for non-wrapping elements`() {
        var header = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring.Header(
            capacity: 8
        )
        header.count = 3

        switch header.initialization {
        case .one(let range):
            #expect(range.lowerBound == 0)
            #expect(range.upperBound == 3)

        default:
            Issue.record("Expected .one initialization")
        }
    }

    @Test
    func `initialization returns .two for wrapping elements`() {
        var header = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring.Header(
            capacity: 4
        )
        header.head = 3
        header.count = 3

        switch header.initialization {
        case .two(let first, let second):
            #expect(first.lowerBound == 3)
            #expect(first.upperBound == 4)
            #expect(second.lowerBound == 0)
            #expect(second.upperBound == 2)

        default:
            Issue.record("Expected .two initialization")
        }
    }

    @Test
    func `Copyable`() {
        let a = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring.Header(
            capacity: 4
        )
        let b = a
        #expect(b.head == a.head)
        #expect(b.count == a.count)
        #expect(b.capacity == a.capacity)
    }
}

extension `Buffer.Ring.Header Tests`.EdgeCase {

    @Test
    func `cyclic head wraps at capacity`() {
        var header = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring.Header(
            capacity: 4
        )
        header.head = 3
        header.count = 1

        switch header.initialization {
        case .one(let range):
            #expect(range.lowerBound == 3)
            #expect(range.upperBound == 4)

        default:
            Issue.record("Expected .one")
        }
    }

    @Test
    func `full capacity produces .one or .two depending on head`() {
        var header = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring.Header(
            capacity: 4
        )
        header.count = 4

        switch header.initialization {
        case .one(let range):
            #expect(range.lowerBound == 0)
            #expect(range.upperBound == 4)

        default:
            Issue.record("Expected .one for head=0 full")
        }

        header.head = 2

        switch header.initialization {
        case .two(let first, let second):
            #expect(first.lowerBound == 2)
            #expect(first.upperBound == 4)
            #expect(second.lowerBound == 0)
            #expect(second.upperBound == 2)

        default:
            Issue.record("Expected .two for head=2 full")
        }
    }
}

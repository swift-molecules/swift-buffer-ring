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
import Cardinal
import Cardinal_Standard_Library_Integration
import Memory_Small
import Buffer_Ring
import Buffer_Ring_Test_Support
import Memory
import Storage_Memory
import Tagged
import Tagged_Standard_Library_Integration
import Testing

@Suite
struct `Buffer.Ring.Bounded+Builder Tests` {
    @Suite struct WithinCapacity {}
    @Suite struct Overflow {}
    @Suite struct NonCopyable {}
}

private struct Move: ~Copyable {
    let value: Int
    init(_ value: Int) { self.value = value }
}

extension `Buffer.Ring.Bounded+Builder Tests`.WithinCapacity {

    @Test
    func `Constructs within capacity`() throws {
        let ring = try Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring.Bounded(
            minimumCapacity: .init(_unchecked: Cardinal(UInt(8)))
        ) {
            1
            2
            3
        }
        #expect(ring.count.underlying.rawValue == 3)
    }
}

extension `Buffer.Ring.Bounded+Builder Tests`.Overflow {

    @Test
    func `Throws on overflow`() {
        do throws(Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring.Bounded.Error)
        {
            _ = try Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Ring.Bounded(
                minimumCapacity: .init(_unchecked: Cardinal(UInt(2)))
            ) {
                1
                2
                3
            }
            Issue.record("expected throw")
        } catch let error {
            #expect(error == .capacityExceeded)
        }
    }
}

extension `Buffer.Ring.Bounded+Builder Tests`.NonCopyable {

    @Test
    func `Constructs noncopyable bounded ring`() throws {
        let ring = try Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Move>>.Ring.Bounded(
            minimumCapacity: .init(_unchecked: Cardinal(UInt(4)))
        ) {
            Move(1)
            Move(2)
        }
        #expect(ring.count.underlying.rawValue == 2)
    }
}

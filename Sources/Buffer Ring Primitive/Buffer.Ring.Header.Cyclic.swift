public import Cyclic
public import Cyclic_Group_Static
public import Cyclic_Group_Static_Element
public import Sequence_Protocol
public import Iterator_Chunk
public import Iterable
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
public import Index

extension Buffer.Ring.Header where S: ~Copyable {

    @frozen
    public struct Cyclic<let capacity: Int>: Copyable, Sendable {

        public var head: Tagged<S.Element, Cyclic::Cyclic.Group.Static<capacity>.Element>

        public var count: Tagged<S.Element, Cardinal>

        @inlinable
        public init() {

            self.head = Tagged(_unchecked: Cyclic::Cyclic.Group.Static<capacity>.Element(__unchecked: .zero))
            self.count = .zero
        }
    }
}

extension Buffer.Ring.Header.Cyclic where S: ~Copyable {

    @inlinable
    public var isEmpty: Bool { count == .zero }

    @inlinable
    public var isFull: Bool { count == Self.slotCapacity }

    @inlinable
    public static var slotCapacity: Tagged<S.Element, Cardinal> {
        Tagged<S.Element, Cardinal>(UInt(capacity))
    }
}

extension Buffer.Ring.Header.Cyclic where S: ~Copyable {

    @inlinable
    public var initialization: Store.Initialization<S.Element> { .init(self) }
}

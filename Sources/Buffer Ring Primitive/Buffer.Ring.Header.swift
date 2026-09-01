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
public import Affine_Standard_Library_Integration
public import Index
public import Ordinal_Standard_Library_Integration

extension Buffer.Ring where S: ~Copyable {

    @frozen
    public struct Header: Copyable, Sendable {

        public var head: Index<S.Element>

        public var count: Tagged<S.Element, Cardinal>

        public let capacity: Tagged<S.Element, Cardinal>

        @inlinable
        public init(capacity: Tagged<S.Element, Cardinal>) {
            self.head = .zero
            self.count = .zero
            self.capacity = capacity
        }
    }
}

extension Buffer.Ring.Header where S: ~Copyable {

    @inlinable
    public var isEmpty: Bool { count == .zero }

    @inlinable
    public var isFull: Bool { count == capacity }
}

extension Buffer.Ring.Header where S: ~Copyable {

    @inlinable
    public var initialization: Store.Initialization<S.Element> { .init(self) }
}

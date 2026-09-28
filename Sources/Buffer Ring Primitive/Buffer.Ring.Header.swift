import Sequence
import Iterator
public import Store
import Span
import Ownership
import Cardinal
import Ordinal
import Property
import Tagged
import Carrier
public import Ordinal
public import Tagged
public import Cardinal
import Difference
public import Index

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

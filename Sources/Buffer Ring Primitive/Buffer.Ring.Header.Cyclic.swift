public import Cardinal
import Carrier
public import Cyclic
import Index
import Iterator
public import Ordinal
import Ownership
import Property
import Sequence
import Span
public import Store
public import Tagged

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

public import Cyclic
import Sequence
import Iterator
public import Store
import Span
import Ownership
import Ordinal_Tagged
import Ordinal_Cardinal
public import Ordinal
import Cardinal_Tagged
public import Tagged
public import Cardinal
import Index

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

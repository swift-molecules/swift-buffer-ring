public import Tagged
public import Cardinal
import Index

extension Buffer.Ring.Header where S: ~Copyable {

    @frozen
    public struct Cyclic<let capacity: Int>: Copyable, Sendable {

        public var head: Index<S.Element>.Cyclic<capacity>

        public var count: Tagged<S.Element, Cardinal>

        @inlinable
        public init() {

            self.head = Index<S.Element>.Cyclic<capacity>(__unchecked: Int.zero)
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

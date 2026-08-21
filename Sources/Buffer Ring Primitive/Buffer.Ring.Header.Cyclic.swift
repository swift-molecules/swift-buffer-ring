import Affine_Primitives_Standard_Library_Integration
import Index_Primitives
import Ordinal_Primitives_Standard_Library_Integration

extension Buffer.Ring.Header where S: ~Copyable {

    @frozen
    public struct Cyclic<let capacity: Int>: Copyable, Sendable {

        public var head: Index<S.Element>.Cyclic<capacity>

        public var count: Index<S.Element>.Count

        @inlinable
        public init() {

            self.head = Index<S.Element>.Cyclic<capacity>(__unchecked: Ordinal(0))
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
    public static var slotCapacity: Index<S.Element>.Count {
        Index<S.Element>.Count(UInt(capacity))
    }
}

extension Buffer.Ring.Header.Cyclic where S: ~Copyable {

    @inlinable
    public var initialization: Store.Initialization<S.Element> { .init(self) }
}

import Affine_Standard_Library_Integration
public import Buffer_Protocol
import Ordinal_Standard_Library_Integration

extension Buffer.Ring where S: ~Copyable {

    @resultBuilder
    public enum Builder {

        @inlinable
        public static func buildExpression<E: ~Copyable>(
            _ expression: consuming E
        ) -> Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring
        where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
            var result = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring(
                minimumCapacity: .one
            )
            result.push.back(consume expression)
            return result
        }

        @inlinable
        public static func buildExpression<E: ~Copyable>(
            _ expression:
                consuming Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring
        ) -> Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring
        where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
            consume expression
        }

        @inlinable
        public static func buildExpression<E: ~Copyable>(
            _ expression: consuming E?
        ) -> Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring
        where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
            var result = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring(
                minimumCapacity: .zero
            )
            if let value = consume expression {
                result.push.back(consume value)
            }
            return result
        }

        @inlinable
        public static func buildPartialBlock<E: ~Copyable>(
            first: consuming Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring
        ) -> Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring
        where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
            consume first
        }

        @inlinable
        public static func buildPartialBlock<E: ~Copyable>(
            first: Void
        ) -> Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring
        where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
            Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring(
                minimumCapacity: .zero
            )
        }

        @inlinable
        public static func buildPartialBlock<E: ~Copyable>(
            first: Never
        ) -> Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring
        where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {}

        @inlinable
        public static func buildPartialBlock<E: ~Copyable>(
            accumulated:
                consuming Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring,
            next: consuming Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring
        ) -> Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring
        where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
            var result = consume accumulated
            var rest = consume next
            while !rest.isEmpty {
                result.push.back(rest.pop.front())
            }
            return result
        }

        @inlinable
        public static func buildBlock<E: ~Copyable>()
            -> Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring
        where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
            Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring(
                minimumCapacity: .zero
            )
        }

        @inlinable
        public static func buildOptional<E: ~Copyable>(
            _ component:
                consuming Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring?
        ) -> Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring
        where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
            if let result = consume component {
                return consume result
            }
            return Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring(
                minimumCapacity: .zero
            )
        }

        @inlinable
        public static func buildEither<E: ~Copyable>(
            first: consuming Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring
        ) -> Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring
        where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
            consume first
        }

        @inlinable
        public static func buildEither<E: ~Copyable>(
            second: consuming Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring
        ) -> Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring
        where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
            consume second
        }

        @inlinable
        public static func buildLimitedAvailability<E: ~Copyable>(
            _ component: consuming Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring
        ) -> Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring
        where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
            consume component
        }
    }
}

extension Buffer.Ring where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable>(@Buffer.Ring.Builder _ builder: () -> Self)
    where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
        self = builder()
    }
}

extension Buffer.Ring.Builder where S: ~Copyable {

    @inlinable
    public static func buildExpression<E, Seq: Swift.Sequence>(
        _ expression: Seq
    ) -> Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring
    where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>, E: Copyable, Seq.Element == E {
        var result = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring(
            minimumCapacity: .zero
        )
        for value in expression {
            result.push.back(value)
        }
        return result
    }
}

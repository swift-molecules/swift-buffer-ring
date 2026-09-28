public import Memory
import Sequence
import Iterator
import Index
public import Tagged
import Store
import Span
import Ownership
import Cardinal
import Ordinal
import Property
import Tagged
import Carrier
public import Cardinal
public import Memory_Small
import Difference
public import Buffer
public import Memory_Allocator_Protocol

extension Buffer.Ring where S: ~Copyable {

    @resultBuilder
    public enum Builder {

        @inlinable
        public static func buildExpression<E: ~Copyable, Resource: Memory.Growable & ~Copyable>(
            _ expression: consuming E
        ) -> Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring
        where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
            var result = Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring(
                minimumCapacity: .one
            )
            result.push.back(consume expression)
            return result
        }

        @inlinable
        public static func buildExpression<E: ~Copyable, Resource: Memory.Growable & ~Copyable>(
            _ expression:
                consuming Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring
        ) -> Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring
        where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
            consume expression
        }

        @inlinable
        public static func buildExpression<E: ~Copyable, Resource: Memory.Growable & ~Copyable>(
            _ expression: consuming E?
        ) -> Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring
        where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
            var result = Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring(
                minimumCapacity: .zero
            )
            if let value = consume expression {
                result.push.back(consume value)
            }
            return result
        }

        @inlinable
        public static func buildPartialBlock<E: ~Copyable, Resource: Memory.Growable & ~Copyable>(
            first: consuming Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring
        ) -> Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring
        where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
            consume first
        }

        @inlinable
        public static func buildPartialBlock<E: ~Copyable, Resource: Memory.Growable & ~Copyable>(
            first: Void
        ) -> Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring
        where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
            Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring(
                minimumCapacity: .zero
            )
        }

        @inlinable
        public static func buildPartialBlock<E: ~Copyable, Resource: Memory.Growable & ~Copyable>(
            first: Never
        ) -> Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring
        where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {}

        @inlinable
        public static func buildPartialBlock<E: ~Copyable, Resource: Memory.Growable & ~Copyable>(
            accumulated:
                consuming Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring,
            next: consuming Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring
        ) -> Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring
        where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
            var result = consume accumulated
            var rest = consume next
            while !rest.isEmpty {
                result.push.back(rest.pop.front())
            }
            return result
        }

        @inlinable
        public static func buildBlock<E: ~Copyable, Resource: Memory.Growable & ~Copyable>()
            -> Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring
        where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
            Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring(
                minimumCapacity: .zero
            )
        }

        @inlinable
        public static func buildOptional<E: ~Copyable, Resource: Memory.Growable & ~Copyable>(
            _ component:
                consuming Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring?
        ) -> Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring
        where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
            if let result = consume component {
                return consume result
            }
            return Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring(
                minimumCapacity: .zero
            )
        }

        @inlinable
        public static func buildEither<E: ~Copyable, Resource: Memory.Growable & ~Copyable>(
            first: consuming Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring
        ) -> Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring
        where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
            consume first
        }

        @inlinable
        public static func buildEither<E: ~Copyable, Resource: Memory.Growable & ~Copyable>(
            second: consuming Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring
        ) -> Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring
        where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
            consume second
        }

        @inlinable
        public static func buildLimitedAvailability<E: ~Copyable, Resource: Memory.Growable & ~Copyable>(
            _ component: consuming Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring
        ) -> Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring
        where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
            consume component
        }
    }
}

extension Buffer.Ring where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable, Resource: Memory.Growable & ~Copyable>(@Buffer.Ring.Builder _ builder: () -> Self)
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
        self = builder()
    }
}

extension Buffer.Ring.Builder where S: ~Copyable {

    @inlinable
    public static func buildExpression<E, Seq: Swift.Sequence, Resource: Memory.Growable & ~Copyable>(
        _ expression: Seq
    ) -> Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<E>, E: Copyable, Seq.Element == E {
        var result = Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring(
            minimumCapacity: .zero
        )
        for value in expression {
            result.push.back(value)
        }
        return result
    }
}

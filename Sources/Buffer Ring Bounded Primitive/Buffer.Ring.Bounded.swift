public import Buffer
import Cardinal
import Carrier
public import Cyclic
import Difference
import Index
import Iterator
public import Memory
public import Memory_Allocator
public import Memory_Allocator_Protocol
import Memory_Small
import Ordinal
import Ownership
import Property
import Sequence
import Span
import Storage
public import Store
import Tagged

extension Buffer.Ring where S: ~Copyable {

    @frozen
    public struct Bounded: ~Copyable {

        @usableFromInline
        var header: Header

        @usableFromInline
        var storage: S

        @inlinable
        package init(header: Header, storage: consuming S) {
            self.header = header
            self.storage = storage
        }
    }
}

extension Buffer.Ring.Bounded: @unsafe @unchecked Sendable
where S: Store.`Protocol` & ~Copyable & Sendable {}

extension Buffer.Ring.Bounded where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        minimumCapacity: Tagged<E, Cardinal>,
        @Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring.Builder _ builder: () ->
            Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Ring
    ) throws(Self.Error) where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
        var dynamic = builder()
        guard dynamic.count <= minimumCapacity else {
            throw .capacityExceeded
        }
        self.init(minimumCapacity: minimumCapacity)
        while !dynamic.isEmpty {
            _ = self.push.back(dynamic.pop.front())
        }
    }
}

extension Buffer.Ring.Bounded where S: ~Copyable {

    @inlinable
    public var checkpoint: Buffer.Ring.Checkpoint {
        Buffer.Ring.Checkpoint(head: header.head, count: header.count)
    }

    @inlinable
    public mutating func restore(to checkpoint: Buffer.Ring.Checkpoint)
    where S: Store.Ledgered.`Protocol` {
        header.head = checkpoint.head
        header.count = checkpoint.count
        storage.initialization = header.initialization
    }
}

extension Buffer.Ring.Bounded where S: ~Copyable {

    @inlinable
    public init<Element: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        minimumCapacity: Tagged<Element, Cardinal>
    ) where S == Storage<Memory.Allocator<Resource>>.Contiguous<Element> {
        let storage = S.create(minimumCapacity: minimumCapacity)
        self.init(
            header: Buffer.Ring.Header(capacity: storage.capacity),
            storage: storage
        )
    }

    @inlinable
    public var count: Tagged<S.Element, Cardinal> { header.count }

    @inlinable
    public var capacity: Tagged<S.Element, Cardinal> { header.capacity }

    @inlinable
    public var isEmpty: Bool { header.isEmpty }

    @inlinable
    public var isFull: Bool { header.isFull }
}

extension Buffer.Ring.Bounded where S: ~Copyable {

    @usableFromInline
    mutating func _pushBack(_ element: consuming S.Element) -> S.Element?
    where S: Store.Ledgered.`Protocol` {
        if header.isFull { return element }
        Buffer.Ring.pushBack(consume element, header: &header, storage: &storage)
        return nil
    }

    @usableFromInline
    mutating func _popFront() -> S.Element where S: Store.Ledgered.`Protocol` {
        Buffer.Ring.popFront(header: &header, storage: &storage)
    }

    @usableFromInline
    mutating func _pushFront(_ element: consuming S.Element) -> S.Element?
    where S: Store.Ledgered.`Protocol` {
        if header.isFull { return element }
        Buffer.Ring.pushFront(consume element, header: &header, storage: &storage)
        return nil
    }

    @usableFromInline
    mutating func _popBack() -> S.Element where S: Store.Ledgered.`Protocol` {
        Buffer.Ring.popBack(header: &header, storage: &storage)
    }

    @usableFromInline
    mutating func _removeAll() where S: Store.Ledgered.`Protocol` {
        Buffer.Ring.deinitializeAll(header: &header, storage: &storage)
    }
}

extension Buffer.Ring.Bounded where S: ~Copyable {

    @inlinable
    public var push: Push.View {
        mutating _read {
            yield.init(&self)
        }
        mutating _modify {
            var view: Push.View = .init(&self)
            yield &view
        }
    }

    @inlinable
    public var pop: Pop.View {
        mutating _read {
            yield.init(&self)
        }
        mutating _modify {
            var view: Pop.View = .init(&self)
            yield &view
        }
    }

    @inlinable
    public var peek: Peek.View {
        _read {
            yield Peek.View(self)
        }
    }

    @inlinable
    public var remove: Remove.View {
        mutating _read {
            yield.init(&self)
        }
        mutating _modify {
            var view: Remove.View = .init(&self)
            yield &view
        }
    }
}

extension Buffer.Ring.Bounded where S: ~Copyable {

    @inlinable
    public subscript(index: Index<S.Element>) -> S.Element {
        _read {
            let physical = Index.Modular.physical(
                forLogical: index,
                head: header.head,
                capacity: header.capacity
            )
            yield storage[physical]
        }
        _modify {
            let physical = Index.Modular.physical(
                forLogical: index,
                head: header.head,
                capacity: header.capacity
            )
            yield &storage[physical]
        }
    }
}

extension Buffer.Ring.Bounded where S: ~Copyable {

    @inlinable
    public func withFront<R: ~Copyable>(_ body: (borrowing S.Element) -> R) -> R {
        return body(storage[header.head])
    }

    @inlinable
    public func withBack<R: ~Copyable>(_ body: (borrowing S.Element) -> R) -> R {
        return body(
            storage[
                Index.Modular.advanced(
                    header.head,
                    by: Index<S.Element>.Offset(
                        header.count.subtract.saturating(.one)
                    ),
                    capacity: header.capacity
                )
            ]
        )
    }
}

extension Buffer.Ring.Bounded where S: ~Copyable {

    @inlinable
    public func clone<Element, Resource: Memory.Growable & ~Copyable>() -> Self
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<Element>, Element: Copyable {
        var fresh = S.create(minimumCapacity: header.capacity)
        var slot: Index<Element> = .zero
        let end = header.count.map { Ordinal($0.rawValue) }
        while slot < end {
            fresh.initialize(at: slot, to: self[slot])
            slot = (slot + Tagged<Element, Cardinal>.one)
        }
        var copy = Self(header: Buffer.Ring.Header(capacity: fresh.capacity), storage: fresh)
        copy.header.count = header.count
        copy.storage.initialization = .init(copy.header)
        return copy
    }
}

extension Buffer.Ring.Bounded where S: ~Copyable {

    @inlinable
    public func forEach(_ body: (borrowing S.Element) -> Void) {
        header.initialization.forEach { range in
            var slot = range.lowerBound
            while slot < range.upperBound {
                body(storage[slot])
                slot += .one
            }
        }
    }
}

import Cardinal
import Carrier
import Difference
import Index
import Iterator
import Ordinal
import Ownership
import Property
import Sequence
import Span
import Storage
public import Store
import Tagged
public import Cyclic
public import Memory_Allocator
public import Memory_Allocator_Protocol

extension Buffer where S: Store.`Protocol`, S: ~Copyable {

    @frozen
    public struct Ring: ~Copyable {

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

extension Buffer.Ring: @unsafe @unchecked Sendable
where S: Store.`Protocol` & ~Copyable & Sendable {}

extension Buffer.Ring where S: ~Copyable {

    @inlinable
    public var checkpoint: Checkpoint {
        Checkpoint(head: header.head, count: header.count)
    }

    @inlinable
    public mutating func restore(to checkpoint: Checkpoint)
    where S: Store.Ledgered.`Protocol` {
        header.head = checkpoint.head
        header.count = checkpoint.count
        storage.initialization = header.initialization
    }
}

extension Buffer.Ring where S: ~Copyable {

    @inlinable
    public static func pushBack(
        _ element: consuming S.Element,
        header: inout Header,
        storage: inout S
    ) where S: Store.Ledgered.`Protocol` {
        let countOffset = Index<S.Element>.Offset(header.count)
        let tail = Index.Modular.advanced(header.head, by: countOffset, capacity: header.capacity)

        storage.initialize(at: tail, to: consume element)

        header.count = header.count.add.saturating(.one)

        storage.initialization = header.initialization
    }

    @inlinable
    public static func popFront(
        header: inout Header,
        storage: inout S
    ) -> S.Element where S: Store.Ledgered.`Protocol` {
        let element = storage.move(at: header.head)

        header.head = Index.Modular.successor(of: header.head, capacity: header.capacity)

        header.count = header.count.subtract.saturating(.one)

        storage.initialization = header.initialization

        return element
    }

    @inlinable
    public static func pushFront(
        _ element: consuming S.Element,
        header: inout Header,
        storage: inout S
    ) where S: Store.Ledgered.`Protocol` {
        header.head = Index.Modular.predecessor(of: header.head, capacity: header.capacity)

        storage.initialize(at: header.head, to: consume element)

        header.count = header.count.add.saturating(.one)

        storage.initialization = header.initialization
    }

    @inlinable
    public static func popBack(
        header: inout Header,
        storage: inout S
    ) -> S.Element where S: Store.Ledgered.`Protocol` {
        let newCount = header.count.subtract.saturating(.one)
        let lastOffset = Index<S.Element>.Offset(newCount)
        let lastSlot = Index.Modular.advanced(
            header.head,
            by: lastOffset,
            capacity: header.capacity
        )

        let element = storage.move(at: lastSlot)

        header.count = newCount

        storage.initialization = header.initialization

        return element
    }

    @inlinable
    public static func physicalSlot(
        forLogical logicalIndex: Index<S.Element>,
        header: Header
    ) -> Index<S.Element> {
        Index.Modular.physical(
            forLogical: logicalIndex,
            head: header.head,
            capacity: header.capacity
        )
    }

    @inlinable
    public static func deinitializeAll(
        header: inout Header,
        storage: inout S
    ) where S: Store.Ledgered.`Protocol` {
        while !header.isEmpty {
            _ = popFront(header: &header, storage: &storage)
        }
        header.head = .zero
        storage.initialization = .empty
    }
}

extension Buffer.Ring where S: ~Copyable {

    @inlinable
    public init<Element: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        minimumCapacity: Tagged<Element, Cardinal>
    )
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<Element> {
        let storage = S.create(minimumCapacity: minimumCapacity)
        self.init(
            header: Self.Header(capacity: storage.capacity),
            storage: storage
        )
    }

    @inlinable
    public init<Element: ~Copyable, Resource: Memory.Growable & ~Copyable>()
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<Element> {
        self.init(minimumCapacity: Tagged<Element, Cardinal>.zero)
    }

    @inlinable
    public var count: Tagged<S.Element, Cardinal> { header.count }

    @inlinable
    public var capacity: Tagged<S.Element, Cardinal> { header.capacity }

    @inlinable
    public var isEmpty: Bool { header.isEmpty }

    @inlinable
    public var isFull: Bool { header.isFull }

    @inlinable
    public mutating func reserveCapacity<Element: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        _ minimumCapacity: Tagged<Element, Cardinal>
    )
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<Element> {
        if minimumCapacity > header.capacity {
            _growTo(minimumCapacity)
        }
    }

    @inlinable
    package mutating func _grow<Element: ~Copyable, Resource: Memory.Growable & ~Copyable>()
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<Element> {
        if header.capacity == .zero {
            _growTo(.one)
        } else {
            _growTo(header.capacity.add.saturating(header.capacity))
        }
    }

    @inlinable
    package mutating func _growTo<Element: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        _ minimumCapacity: Tagged<Element, Cardinal>
    )
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<Element> {
        var newStorage = S.create(minimumCapacity: minimumCapacity)

        let newCapacity = newStorage.capacity
        let oldCount = header.count

        header.initialization.linearize { range, offset in
            var src = range.lowerBound
            var dst = offset
            while src < range.upperBound {
                newStorage.initialize(at: dst, to: storage.move(at: src))
                src += Tagged<Element, Cardinal>.one
                dst += Tagged<Element, Cardinal>.one
            }
        }
        storage = newStorage
        header = Self.Header(capacity: newCapacity)
        header.count = oldCount

        storage.initialization = header.initialization
    }

    @inlinable
    public mutating func compact<Element: ~Copyable, Resource: Memory.Growable & ~Copyable>()
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<Element> {
        guard header.count < header.capacity else { return }
        if header.isEmpty {
            storage = S.create(minimumCapacity: .zero)
            header = .init(capacity: storage.capacity)
            return
        }
        _growTo(header.count)
    }
}

extension Buffer.Ring where S: ~Copyable {

    @usableFromInline
    mutating func _pushBack<Element: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        _ element: consuming Element
    )
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<Element> {
        if header.isFull { _grow() }
        Self.pushBack(consume element, header: &header, storage: &storage)
    }

    @usableFromInline
    mutating func _popFront() -> S.Element
    where S: Store.Ledgered.`Protocol` {
        Self.popFront(header: &header, storage: &storage)
    }

    @usableFromInline
    mutating func _pushFront<Element: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        _ element: consuming Element
    )
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<Element> {
        if header.isFull { _grow() }
        Self.pushFront(consume element, header: &header, storage: &storage)
    }

    @usableFromInline
    mutating func _popBack() -> S.Element
    where S: Store.Ledgered.`Protocol` {
        Self.popBack(header: &header, storage: &storage)
    }

    @usableFromInline
    mutating func _removeAll()
    where S: Store.Ledgered.`Protocol` {
        Self.deinitializeAll(header: &header, storage: &storage)
    }

    @inlinable
    public mutating func pushBack<Element: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        _ element: consuming Element
    )
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<Element> {
        _pushBack(consume element)
    }

    @inlinable
    public mutating func pushFront<Element: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        _ element: consuming Element
    )
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<Element> {
        _pushFront(consume element)
    }

    @inlinable
    public mutating func popFront() -> S.Element
    where S: Store.Ledgered.`Protocol` {
        _popFront()
    }

    @inlinable
    public mutating func popBack() -> S.Element
    where S: Store.Ledgered.`Protocol` {
        _popBack()
    }

    @inlinable
    public mutating func removeAll()
    where S: Store.Ledgered.`Protocol` {
        _removeAll()
    }
}

extension Buffer.Ring where S: ~Copyable {

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

extension Buffer.Ring where S: ~Copyable {

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

extension Buffer.Ring where S: ~Copyable {

    @inlinable
    public var substrate: S {
        _read { yield storage }
    }
}

extension Buffer.Ring where S: ~Copyable {

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

    @inlinable
    public func peekFront() -> S.Element where S.Element: Copyable {
        withFront { $0 }
    }

    @inlinable
    public func peekBack() -> S.Element where S.Element: Copyable {
        withBack { $0 }
    }
}

extension Buffer.Ring where S: ~Copyable {

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
        var copy = Self(header: Header(capacity: fresh.capacity), storage: fresh)
        copy.header.count = header.count
        copy.storage.initialization = .init(copy.header)
        return copy
    }
}

extension Buffer.Ring where S: ~Copyable {

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

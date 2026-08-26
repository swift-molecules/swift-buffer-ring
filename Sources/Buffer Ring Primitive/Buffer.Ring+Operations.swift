import Affine_Standard_Library_Integration
import Index
public import Memory_Allocator_Primitive
public import Memory_Allocator_Protocol
import Ordinal_Standard_Library_Integration
public import Storage_Contiguous
public import Storage_Primitive
public import Store_Ledgered

extension Buffer.Ring where S: ~Copyable {

    @inlinable
    public init<Element: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        minimumCapacity: Index<Element>.Count
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
        self.init(minimumCapacity: Index<Element>.Count.zero)
    }

    @inlinable
    public var count: Index<S.Element>.Count { header.count }

    @inlinable
    public var capacity: Index<S.Element>.Count { header.capacity }

    @inlinable
    public var isFull: Bool { header.isFull }

    @inlinable
    public mutating func reserveCapacity<Element: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        _ minimumCapacity: Index<Element>.Count
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
            _growTo(header.capacity * 2)
        }
    }

    @inlinable
    package mutating func _growTo<Element: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        _ minimumCapacity: Index<Element>.Count
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
                src += .one
                dst += .one
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

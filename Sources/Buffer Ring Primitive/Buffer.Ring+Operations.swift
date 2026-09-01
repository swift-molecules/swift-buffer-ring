public import Sequence_Protocol
public import Iterator_Chunk
public import Iterable
public import Store_Ledgered
public import Store_Initialization
public import Store_Operations
public import Store_Protocol
public import Store
public import Span_Protocol
public import Ownership_Inout
public import Ownership_Borrow
public import Ordinal_Tagged
public import Ordinal_Protocol
public import Ordinal_Cardinal
public import Ordinal
public import Cardinal_Tagged
public import Cardinal_Carrier
public import Tagged
public import Cardinal
public import Affine_Standard_Library_Integration
public import Index
public import Memory_Allocator
public import Memory_Allocator_Protocol
public import Ordinal_Standard_Library_Integration
public import Property_Ownership
public import Storage_Memory
public import Storage

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

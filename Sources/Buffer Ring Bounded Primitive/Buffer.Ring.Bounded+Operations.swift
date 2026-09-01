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
public import Memory_Allocator_Protocol
public import Ordinal_Standard_Library_Integration
public import Property_Ownership
public import Storage

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

public import Cyclic_Group_Static_Element
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
public import Cardinal_Tagged
public import Cardinal_Carrier
public import Cardinal
public import Index
public import Ordinal
public import Storage
public import Tagged

extension Store.Initialization where Element: ~Copyable & ~Escapable {

    @inlinable
    public init<S: Store.`Protocol` & ~Copyable>(
        _ header: Buffer<S>.Ring.Header
    ) where S.Element == Element {
        if header.count == .zero {
            self = .empty
            return
        }

        let tail = header.head + header.count
        let capacity = Index<Element>(_unchecked: Ordinal(header.capacity.underlying))

        if tail <= capacity {
            self = .one((header.head)..<((header.head) + header.count))
        } else {
            let firstCount = header.capacity.subtract.saturating(Tagged<Element, Cardinal>(_unchecked: Cardinal(header.head.ordinal))
            )
            self = .two(
                first: (header.head)..<((header.head) + firstCount),
                second: Index<Element>(_unchecked: .zero)..<(Index<Element>(_unchecked: .zero) + header.count.subtract.saturating(firstCount))
            )
        }
    }
}

extension Store.Initialization where Element: ~Copyable & ~Escapable {

    @inlinable
    public init<S: Store.`Protocol` & ~Copyable, let capacity: Int>(
        _ header: Buffer<S>.Ring.Header.Cyclic<capacity>
    ) where S.Element == Element {
        if header.count == .zero {
            self = .empty
            return
        }

        let slotCapacity = Buffer<S>.Ring.Header.Cyclic<capacity>.slotCapacity
        let headIndex = header.head.map { $0.position }
        let tail = (headIndex + header.count)

        if tail <= Index<Element>(_unchecked: Ordinal(slotCapacity.underlying)) {
            self = .one((headIndex)..<((headIndex) + header.count))
        } else {
            let firstCount = slotCapacity.subtract.saturating(Tagged<Element, Cardinal>(_unchecked: Cardinal(headIndex.ordinal))
            )
            self = .two(
                first: (headIndex)..<((headIndex) + firstCount),
                second: Index<Element>(_unchecked: .zero)..<(Index<Element>(_unchecked: .zero) + header.count.subtract.saturating(firstCount))
            )
        }
    }
}

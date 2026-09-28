public import Cyclic
import Sequence
import Iterator
public import Store
import Span
import Ownership
import Cardinal
import Ordinal
import Property
import Tagged
import Carrier
public import Cardinal
public import Index
public import Ordinal
import Storage
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

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

        let tail = header.head.advanced(by: header.count)
        let capacity = Index<Element>(header.capacity)

        if tail <= capacity {
            self = .one(Store.Span(start: header.head, count: header.count))
        } else {
            let firstCount = header.capacity.subtracting(
                saturating: Tagged<Element, Cardinal>(header.head)
            )
            self = .two(
                first: Store.Span(start: header.head, count: firstCount),
                second: Store.Span(
                    start: .zero,
                    count: header.count.subtracting(saturating: firstCount)
                )
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
        let tail = headIndex.advanced(by: header.count)

        if tail <= Index<Element>(slotCapacity) {
            self = .one(Store.Span(start: headIndex, count: header.count))
        } else {
            let firstCount = slotCapacity.subtracting(
                saturating: Tagged<Element, Cardinal>(headIndex)
            )
            self = .two(
                first: Store.Span(start: headIndex, count: firstCount),
                second: Store.Span(
                    start: .zero,
                    count: header.count.subtracting(saturating: firstCount)
                )
            )
        }
    }
}

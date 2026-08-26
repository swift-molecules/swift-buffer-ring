import Affine_Standard_Library_Integration
import Ordinal_Standard_Library_Integration
import Storage_Protocol
public import Store_Initialization
public import Store_Protocol

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

        if tail <= header.capacity {
            self = .one(header.head..<tail)
        } else {
            self = .two(
                first: header.head..<header.capacity.map(Ordinal.init),
                second:
                    .zero..<Index<Element>.Count(tail).subtract.saturating(header.capacity).map(
                        Ordinal.init
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
        let tail = headIndex + header.count

        if tail <= slotCapacity {
            self = .one(headIndex..<tail)
        } else {
            self = .two(
                first: headIndex..<slotCapacity.map(Ordinal.init),
                second:
                    .zero..<Index<Element>.Count(tail).subtract.saturating(slotCapacity).map(
                        Ordinal.init
                    )
            )
        }
    }
}

public import Buffer
public import Cardinal
public import Index
public import Ordinal_Protocol
public import Tagged

extension Buffer.Ring.Bounded: Buffer.`Protocol` where S: ~Copyable {

    public typealias Element = S.Element
}

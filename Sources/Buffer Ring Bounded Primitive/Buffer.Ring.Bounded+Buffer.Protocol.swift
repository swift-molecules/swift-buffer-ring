public import Buffer_Protocol

extension Buffer.Ring.Bounded: Buffer.`Protocol` where S: ~Copyable {

    public typealias Element = S.Element
}

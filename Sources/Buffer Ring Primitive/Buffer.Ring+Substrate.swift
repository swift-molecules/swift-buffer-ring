import Storage_Protocol

extension Buffer.Ring where S: ~Copyable {

    @inlinable
    public var substrate: S {
        _read { yield storage }
    }
}

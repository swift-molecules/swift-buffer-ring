public import Store_Ledgered
public import Store_Protocol

extension Buffer.Ring: Store.Direct where S: Store.Ledgered.`Protocol`, S: ~Copyable {}

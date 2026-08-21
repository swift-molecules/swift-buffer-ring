public import Store_Ledgered_Primitives
public import Store_Protocol_Primitives

extension Buffer.Ring: Store.Direct where S: Store.Ledgered.`Protocol`, S: ~Copyable {}

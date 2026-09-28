import Sequence
import Iterator
import Index
import Tagged
public import Store
import Span
import Ownership
import Cardinal
import Ordinal
import Property
import Carrier
import Storage

extension Buffer.Ring: Store.Direct where S: Store.Ledgered.`Protocol`, S: ~Copyable {}

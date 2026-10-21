import Cardinal
import Carrier
import Index
import Iterator
import Ordinal
import Ownership
import Property
import Sequence
import Span
import Storage
public import Store
import Tagged

extension Buffer.Ring: Store.Direct where S: Store.Ledgered.`Protocol`, S: ~Copyable {}

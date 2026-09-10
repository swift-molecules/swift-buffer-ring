import Sequence
import Iterator
import Index
import Tagged
public import Store
import Span
import Ownership
import Ordinal_Tagged
import Ordinal_Cardinal
import Ordinal
import Cardinal_Tagged
import Cardinal
import Storage

extension Buffer.Ring: Store.Direct where S: Store.Ledgered.`Protocol`, S: ~Copyable {}

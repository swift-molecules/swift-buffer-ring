public import Buffer
import Cardinal
import Index
import Ordinal
import Tagged

extension Buffer.Ring: Buffer.`Protocol` where S: ~Copyable {

    public typealias Element = S.Element
}

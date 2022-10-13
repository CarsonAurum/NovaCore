//
//  Created by Carson Rau on 3/29/22.
//

#if canImport(Foundation)
import class Foundation.OperationQueue

extension OperationQueue {
    /// An operation queue capable of only performing a single task at a time.
    @inlinable
    public static var serial: OperationQueue {
        let q = OperationQueue()
        q.maxConcurrentOperationCount = 1
        return q
    }
}
#endif

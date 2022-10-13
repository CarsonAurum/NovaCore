//
//  Created by Carson Rau on 6/9/22.
//

#if canImport(Dispatch)
import Dispatch


extension DispatchQueue {
    /// A boolean value determining whether the current queue is the main queue.
    public var isMainQueue: Bool {
        enum Static {
            static var key: DispatchSpecificKey<Void> = {
                let key = DispatchSpecificKey<Void>()
                DispatchQueue.main.setSpecific(key: key, value: ())
                return key
            }()
        }
        return DispatchQueue.getSpecific(key: Static.key) != nil
    }
    /// Returns a boolean value indicating whether the current dispatch queue is the specified queue.
    ///
    /// - Parameter queue: The queue to compare against.
    /// - Returns: `true` if the current queue matches the specified queue, otherwise `false`.
    public static func isCurrent(_ queue: DispatchQueue) -> Bool {
        let key = DispatchSpecificKey<Void>()

        queue.setSpecific(key: key, value: ())
        defer { queue.setSpecific(key: key, value: nil) }

        return DispatchQueue.getSpecific(key: key) != nil
    }
    /// Runs a passed closure asynchronously after a certain time interval.
    ///
    /// - Parameters:
    ///   - delay: The time interval after which the closure should be executed.
    ///   - qos: Quality of service at which the work item shoulod be executed.
    ///   - flags: Flags that control the execution environment of the work item.
    ///   - work: The closure to run after certain time interval.
    public func asyncAfter(
        delay: Double,
        qos: DispatchQoS = .unspecified,
        flags: DispatchWorkItemFlags = [],
        execute work: @escaping () -> Void
    ) {
        asyncAfter(deadline: .now() + delay, qos: qos, flags: flags, execute: work)
    }
    // TODO: - Document
    public func debounce(
        delay: Double,
        action: @escaping () -> Void
    ) -> () -> Void {
        var lastFireTime = DispatchTime.now()
        let deadline = { lastFireTime + delay }
        return {
            self.asyncAfter(deadline: deadline()) {
                let now = DispatchTime.now()
                if now >= deadline() {
                    lastFireTime = now
                    action()
                }
            }
        }
    }
}
#endif

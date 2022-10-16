//
// An Async DSL library for use with Grand Central Dispatch.
// Created by Carson Rau on 2/28/22.
//

#if canImport(Dispatch)
import Dispatch

// MARK: - Helpers
fileprivate enum GCD {
    case main, userInteractive, userInitiated, utility, background, custom(queue: DispatchQueue)
    var queue: DispatchQueue {
        switch self {
        case .main: return .main
        case .userInteractive: return .global(qos: .userInteractive)
        case .userInitiated: return .global(qos: .userInitiated)
        case .utility: return .global(qos: .utility)
        case .background: return .global(qos: .background)
        case .custom(let queue): return queue
        }
    }
    func `async`(execute block: @escaping @convention(block) () -> Void) {
        queue.async(execute: block)
    }
    func `async`(execute block: DispatchWorkItem) {
        queue.async(execute: block)
    }
    func `async`(group: DispatchGroup, execute block: DispatchWorkItem) {
        queue.async(group: group, execute: block)
    }
    func `async`(group: DispatchGroup, execute block: @escaping @convention(block) () -> Void) {
        queue.async(group: group, execute: block)
    }
    func asyncAfter(deadline time: DispatchTime, execute block: @escaping @convention(block) () -> Void) {
        queue.asyncAfter(deadline: time, execute: block)
    }
    func asyncAfter(deadline time: DispatchTime, execute block: DispatchWorkItem) {
        queue.asyncAfter(deadline: time, execute: block)
    }
}
fileprivate final class ObjectWrapper<T> {
    public var value: T?
    public init(_ value: T? = nil) {
        self.value = value
    }
}

// MARK: - AsyncBlock
/// The primary export of this micro framework: capable of handling a single logical block of work.
///
/// ```
/// Async.background {
///     // Run on background queue
/// }.main {
///     // Run on main queue after the previous block.
/// }
/// ```
///
/// All modern queue classes are supported:
/// ```
/// Async.main {}
/// Async.userInteractive {}
/// Async.userInitiated {}
/// Async.utility {}
/// Async.background {}
/// ```
///
/// Custom `DispatchQueue` types can be used:
/// ```
/// let customQ = dispatch_queue_create("Label", DISPATCH_QUEUE_CONCURRENT)
/// Async.custom(queue: customQ) {}
/// ```
///
/// Dispatch blocks after delay:
/// ```
/// let seconds = 0.5
/// Async.main(after: seconds) { }
/// ```
///
/// Cancel undispatched blocks:
/// ```
/// let block1 = Async.background { /* work */ }
/// let block2 = block1.backgrounds { /* more work */ }
/// Async.main {
///     block1.cancel() // First block is NOT cancelled
///     block2.cancel() // Second block IS cancelled.
/// }
/// ```
///
/// Wait for a block to finish:
/// ```
/// let block = Async.background { /* work */ }
/// // Do more work.
/// block.wait() // Wait for the block to finish.
/// // Do more work.
/// ```
///
///  Internally handles a  `@convention(block) () -> Swift.Void` closure.
public typealias Async = AsyncBlock<Void, Void>
/// AsyncBlocks encapsulate dispatch blocks and enable the use of chaining and other syntax luxuries.
public struct AsyncBlock<Input, Output> {
    private let block: DispatchWorkItem
    private let input: ObjectWrapper<Input>?
    private let output_: ObjectWrapper<Output>
    /// Access the output of this block after execution. Otherwise, `nil`.
    public var output: Output? { output_.value }
    private init(_ block: DispatchWorkItem, input: ObjectWrapper<Input>? = nil, output: ObjectWrapper<Output> = ObjectWrapper()) {
        self.block = block
        self.input = input
        output_ = output
    }
    // MARK: Private
    private static func async<T>(
        after seconds: Double? = nil,
        block: @escaping () -> T,
        queue: GCD
    ) -> AsyncBlock<Void, T> {
        let ref = ObjectWrapper<T>()
        let block = DispatchWorkItem {
            ref.value = block()
        }
        if let seconds = seconds {
            queue.asyncAfter(deadline: .now() + seconds, execute: block)
        } else {
            queue.async(execute: block)
        }
        return AsyncBlock<Void, T>(block, output: ref)
    }
    private func chain<T>(
        after seconds: Double? = nil,
        block chaining: @escaping (Output) -> T,
        queue: GCD
    ) -> AsyncBlock<Output, T> {
        let ref = ObjectWrapper<T>()
        let work = DispatchWorkItem {
            ref.value = chaining(output_.value!)
        }
        if let seconds = seconds {
            block.notify(queue: queue.queue) {
                queue.asyncAfter(deadline: .now() + seconds, execute: work)
            }
        } else {
            block.notify(queue: queue.queue, execute: work)
        }
        return AsyncBlock<Output, T>(work, input: output_, output: ref)
    }
    // MARK: - Static
    
    /// Sends a block to be run asynchronously on the main thread.
    ///
    /// - Note: This function has parity with an instance method to allow chaining.
    ///
    /// - Parameters:
    ///   - seconds: After how many seconds the block should run.
    ///   - block: The work item.
    /// - Returns: An `AsyncBlock` containing this block and its result.
    @discardableResult
    public static func main<T>(after seconds: Double? = nil, _ block: @escaping () -> T) -> AsyncBlock<Void, T> {
        self.async(after: seconds, block: block, queue: .main)
    }
    /// Sends a block to be run asynchronously on a thread with the quality of service `DispatchQoS.userInteractive`.
    ///
    /// - Note: This function has parity with an instance method to allow chaining.
    ///
    /// - Parameters:
    ///   - seconds: After how many seconds the block should run.
    ///   - block: The work item.
    /// - Returns: An `AsyncBlock` containing this block and its result.
    @discardableResult
    public static func userInteractive<T>(
        after seconds: Double? = nil,
        _ block: @escaping () -> T
    ) -> AsyncBlock<Void, T> {
        self.async(after: seconds, block: block, queue: .userInteractive)
    }
    /// Sends a block to be run asynchronously on a thread with the quality of service `DispatchQoS.userInitiated`.
    ///
    /// - Note: This function has parity with an instance method to allow chaining.
    ///
    /// - Parameters:
    ///   - seconds: After how many seconds the block should run.
    ///   - block: The work item.
    /// - Returns: An `AsyncBlock` containing this block and its result.
    @discardableResult
    public static func userInitiated<T>(
        after seconds: Double? = nil,
        _ block: @escaping () -> T
    ) -> AsyncBlock<Void, T> {
        self.async(after: seconds, block: block, queue: .userInitiated)
    }
    /// Sends a block to be run asynchronously on a thread with the quality of service `DispatchQoS.utility`.
    ///
    /// - Note: This function has parity with an instance method to allow chaining.
    ///
    /// - Parameters:
    ///   - seconds: After how many seconds the block should run.
    ///   - block: The work item.
    /// - Returns: An `AsyncBlock` containing this block and its result.
    @discardableResult
    public static func utility<T>(after seconds: Double? = nil, _ block: @escaping () -> T) -> AsyncBlock<Void, T> {
        self.async(after: seconds, block: block, queue: .utility)
    }
    /// Sends a block to be run asynchronously on a thread with the quality of service `DispatchQoS.background`.
    ///
    /// - Note: This function has parity with an instance method to allow chaining.
    ///
    /// - Parameters:
    ///   - seconds: After how many seconds the block should run.
    ///   - block: The work item.
    /// - Returns: An `AsyncBlock` containing this block and its result.
    @discardableResult
    public static func background<T>(after seconds: Double? = nil, _ block: @escaping () -> T) -> AsyncBlock<Void, T> {
        self.async(after: seconds, block: block, queue: .background)
    }
    /// Sends a block to be run asynchronously on a custom queue.
    ///
    /// - Note: This function has parity with an instance method to allow chaining.
    ///
    /// - Parameters:
    ///   - seconds: After how many seconds the block should run.
    ///   - block: The work item.
    /// - Returns: An `AsyncBlock` containing this block and its result.
    @discardableResult
    public static func custom<T>(
        queue: DispatchQueue,
        after seconds: Double? = nil,
        _ block: @escaping () -> T
    ) -> AsyncBlock<Void, T> {
        self.async(after: seconds, block: block, queue: .custom(queue: queue))
    }
    
    // MARK: Instance
    
    /// Sends a block to be run asynchronously on the main thread.
    ///
    /// - Note: This function has parity with a static method.
    ///
    /// - Parameters:
    ///   - seconds: After how many seconds the block should run.
    ///   - block: The work item.
    /// - Returns: An `AsyncBlock` containing this block and its result.
    @discardableResult
    public func main<C>(after seconds: Double? = nil, _ chaining: @escaping (Output) -> C) -> AsyncBlock<Output, C> {
        self.chain(after: seconds, block: chaining, queue: .main)
    }
    /// Sends a block to be run asynchronously on a thread with the quality of service `DispatchQoS.userInteractive`.
    ///
    /// - Note: This function has parity with a static method.
    ///
    /// - Parameters:
    ///   - seconds: After how many seconds the block should run.
    ///   - block: The work item.
    /// - Returns: An `AsyncBlock` containing this block and its result.
    @discardableResult
    public func userInteractive<C>(after seconds: Double? = nil, _ chaining: @escaping (Output) -> C) -> AsyncBlock<Output, C> {
        self.chain(after: seconds, block: chaining, queue: .userInteractive)
    }
    /// Sends a block to be run asynchronously on a thread with the quality of service `DispatchQoS.userInitiated`.
    ///
    /// - Note: This function has parity with a static method.
    ///
    /// - Parameters:
    ///   - seconds: After how many seconds the block should run.
    ///   - block: The work item.
    /// - Returns: An `AsyncBlock` containing this block and its result.
    @discardableResult
    public func userInitiated<C>(after seconds: Double? = nil, _ chaining: @escaping (Output) -> C) -> AsyncBlock<Output, C> {
        self.chain(after: seconds, block: chaining, queue: .userInitiated)
    }
    @discardableResult
    public func utility<C>(after seconds: Double? = nil, _ chaining: @escaping (Output) -> C) -> AsyncBlock<Output, C> {
        self.chain(after: seconds, block: chaining, queue: .utility)
    }
    @discardableResult
    public func background<C>(after seconds: Double? = nil, _ chaining: @escaping (Output) -> C) -> AsyncBlock<Output, C> {
        self.chain(after: seconds, block: chaining, queue: .background)
    }
    @discardableResult
    public func custom<C>(
        queue: DispatchQueue,
        after seconds: Double? = nil,
        _ chaining: @escaping (Output) -> C
    ) -> AsyncBlock<Output, C> {
        self.chain(after: seconds, block: chaining, queue: .custom(queue: queue))
    }
    // MARK: Utils
    /// Cancel an undispatched block.
    ///
    /// - Warning: If a block has already been sent to GCD for execution, it cannot be cancelled. Thus, the first block of a
    /// chain cannot be cancelled.
    ///
    /// ```
    /// let block1 = Async.background { /* work */ }
    /// let block2 = block1.backgrounds { /* more work */ }
    /// Async.main {
    ///     block1.cancel() // First block is NOT cancelled
    ///     block2.cancel() // Second block IS cancelled.
    /// }
    /// ```
    ///
    public func cancel() {
        block.cancel()
    }
    @discardableResult
    public func wait(seconds: Double? = nil) -> DispatchTimeoutResult {
        let timeout = seconds.flatMap { DispatchTime.now() + $0 } ?? .distantFuture
        return block.wait(timeout: timeout)
    }
}

// MARK: - Apply
public struct Apply {
    public static func userInteractive(_ iterations: Int, block: @escaping (Int) -> Void) {
        GCD.userInteractive.async {
            DispatchQueue.concurrentPerform(iterations: iterations, execute: block)
        }
    }
    public static func userInitiated(_ iterations: Int, block: @escaping (Int) -> Void) {
        GCD.userInitiated.async {
            DispatchQueue.concurrentPerform(iterations: iterations, execute: block)
        }
    }
    public static func utility(_ iterations: Int, block: @escaping (Int) -> Void) {
        GCD.utility.async {
            DispatchQueue.concurrentPerform(iterations: iterations, execute: block)
        }
    }
    public static func background(_ iterations: Int, block: @escaping (Int) -> Void) {
        GCD.background.async {
            DispatchQueue.concurrentPerform(iterations: iterations, execute: block)
        }
    }
    public static func custom(queue: DispatchQueue, iterations: Int, block: @escaping (Int) -> Void) {
        queue.async {
            DispatchQueue.concurrentPerform(iterations: iterations, execute: block)
        }
    }
}

// MARK: - AsyncGroup
public struct AsyncGroup {
    private let group = DispatchGroup()
    public init() {}
    private func `async`(block: @escaping @convention(block) () -> Void, queue: GCD) {
        queue.async(group: group, execute: block)
    }
    public func enter() {
        group.enter()
    }
    public func leave() {
        group.leave()
    }
    public func main(_ block: @escaping @convention(block) () -> Void) {
        async(block: block, queue: .main)
    }
    public func userInteractive(_ block: @escaping @convention(block) () -> Void) {
        async(block: block, queue: .userInteractive)
    }
    public func userInitiated(_ block: @escaping @convention(block) () -> Void) {
        async(block: block, queue: .userInitiated)
    }
    public func utility(_ block: @escaping @convention(block) () -> Void) {
        async(block: block, queue: .utility)
    }
    public func background(_ block: @escaping @convention(block) () -> Void) {
        async(block: block, queue: .background)
    }
    public func custom(queue: DispatchQueue, block: @escaping @convention(block) () -> Void) {
        async(block: block, queue: .custom(queue: queue))
    }
    @discardableResult
    public func wait(seconds: Double? = nil) -> DispatchTimeoutResult {
        let timeout = seconds.flatMap { DispatchTime.now() + $0 } ?? .distantFuture
        return group.wait(timeout: timeout)
    }
}
#endif

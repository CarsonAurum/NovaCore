//
// Created by Carson Rau on 3/7/22.
//

/// A "sum iterator" that iterates through the values of two "child" iterators.
public struct Join2Iterator<A: IteratorProtocol, B: IteratorProtocol>: IteratorProtocol
        where A.Element == B.Element {
    /// A value type representing the iterators that are joined as a tuple.
    public typealias Value = (A, B)
    /// Storage for the iterators that make up this joined iterator.
    public private(set) var value: Value
    /// Initialize a new joined iterator with a tuple of iterators.
    ///
    /// - Parameter value: The iterators to be joined.
    public init(_ value: Value) {
        self.value = value
    }
    /// Advances to the next element and returns it, or nil if no next element exists.
    ///
    /// - Returns: The value within the first iterator, or the second if it exists. `nil` otherwise.
    public mutating func next() -> A.Element? {
        value.0.next() ?? value.1.next()
    }
}

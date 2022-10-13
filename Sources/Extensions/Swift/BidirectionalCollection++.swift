//
// Created by Carson Rau on 1/26/22.
//

extension BidirectionalCollection {
    /// Returns the element at the specified position.
    ///
    /// If the offset is negative, the `n`th element from the end will be returned where `n` is the result of `abs(distance)`.
    /// - Parameter offset: The distance to offset.
    public subscript(offset distance: Int) -> Element {
        let index = distance >= 0 ? startIndex : endIndex
        return self[indices.index(index, offsetBy: distance)]
    }
    /// Access the element at the specified position from the end index.
    ///
    /// - Parameter reverse: The index from the end index whose element is desired.
    /// - Returns: The element at the given reverse index.
    public subscript(reverse index: Index) -> Element {
        self[reverse(index: index)]
    }
}

extension BidirectionalCollection {
    /// Access the last populated index in the collection.
    @inlinable
    public var lastIndex: Index { index(before: endIndex) }
    /// View a reversed version of this collection.
    @inlinable
    public var reverseView: ReversedCollection<Self> { reversed() }
}

public extension BidirectionalCollection {
    /// Returns the index immediately before the given index, if present.
    ///
    /// - Parameter index: The index whose previous index should be returned, if available.
    /// - Returns: The index immediately before the given index, or `nil` if the given index is the start index.
    @inlinable
    func index(ifPresentBefore index: Index) -> Index? {
        index != startIndex &&-> self.index(before: index)
    }
    /// Returns the index immediately after the given index, if present.
    ///
    /// - Parameter index: The index whose immediate successor should be returned, if available.
    /// - Returns: The index immediately after the given index, or `nil` if the given index is the end index.
    @inlinable
    func index(ifPresentAfter index: Index) -> Index? {
        index != lastIndex &&-> self.index(after: index)
    }
    /// Returns the last element of the sequence that has a property by the given key path equivalent to the given `value`.
    ///
    /// - Parameters:
    ///   - keyPath: The `KeyPath` of property for `Element` to compare.
    ///   - value: The value to compare with `Element` properties.
    /// - Returns: The last element of the collection that has a property by the given key path equivalent to `value`, or `nil` if
    ///   there is no such element.
    func last <T:Equatable>(
            where keyPath: KeyPath<Element, T>,
            equals value: T
    ) -> Element? {
        last { $0[keyPath: keyPath] == value }
    }
    /// Access the index based on the end index, rather than the standard start index.
    ///
    /// - Parameter index: The index to recalculate.
    /// - Returns: The index as if the start index and last index were reversed. (a reverse index).
    @inlinable
    func reverse(index i: Index) -> Index {
        index(atDistance: distance(from: i, to: lastIndex))
    }
    /// Remove the final element from a collection and access it.
    ///
    /// - Returns: A tuple containing the sub sequence of elements without the final element, and the tail element which is
    ///   separated as the second element. This tuple will be `nil` if there are no elements in the collection.
    @inlinable
    func splittingLast() -> (head: SubSequence, tail: Element)? {
        guard let tail = last else { return nil }
        return (head: prefix(upTo: index(before: endIndex)), tail: tail)
    }
    /// A reversed version of the standard unfolded sequence.
    ///
    /// - Returns: An unfolded sequence starting at the final index of the parent sequence.
    func unfoldBackwards() -> UnfoldSequence<(SubSequence, Element), SubSequence> {
        sequence(state: prefix(upTo: endIndex)) {
            guard let (head, tail) = $0.splittingLast() else { return nil }
            $0 = head
            return (head, tail)
        }
    }
}

// MARK: - Conditional Conformance

extension BidirectionalCollection where Self: MutableCollection {
    /// View a mutable reversed version of this collection.
    @inlinable
    public var reverseView: ReversedCollection<Self> {
        get { reversed() }
        set { self = newValue._base }
    }
    /// Access the element at the specified position from the end index.
    ///
    /// - Parameter reverse: The index from the end index whose element is desired.
    /// - Returns: A mutable version of the element at the given reverse index.
    public subscript(reverse index: Index) -> Element {
        get { self[reverse(index: index)] }
        set { self[reverse(index: index)] = newValue }
    }
    /// Reverse this collection in a mutating fashion.
    @inlinable
    public mutating func reverseInPlace() {
        let breakIdx = index(atDistance: length / 2)
        for index in indices.prefix(till: breakIdx) {
            swapAt(index, reverse(index: index))
        }
    }
    /// Access a reversed copy of this collection.
    /// - Returns: The reversed value.
    @inlinable
    public func reversed() -> Self {
        update(self)  { $0.reverseInPlace() }
    }
}

extension BidirectionalCollection where Element: Equatable {
    /// Determine if a given collection occurs at the end of this collection.
    ///
    /// - Parameter with: The collection whose elements should be checked
    ///   for at the end of self.
    /// - Returns: `true` if the given sequence is the suffix. `false`
    ///   otherwise.
    @inlinable
    public func ends<A: BidirectionalCollection>(with suffix: A) -> Bool
        where A.Element == Element {
        guard count >= suffix.count else { return false }
        return suffix.reversed().zip(reversed()).contains { $0.0 == $0.1 }
    }
}

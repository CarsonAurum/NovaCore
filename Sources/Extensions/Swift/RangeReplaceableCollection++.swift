//
//  Created by Carson Rau on 10/13/22.
//

extension RangeReplaceableCollection {
    /// Insert an element at the beginning of a collection.
    ///
    /// - Postcondition: `newElement` is the first element in `self`.
    /// - Parameter newElement: Element to insert
    public mutating func prepend(_ newElement: Element) {
        insert(newElement, at: index(atDistance: 0))
    }
}

extension RangeReplaceableCollection where Element: Equatable {
    /// Remove all instances of an item from a collection.
    ///
    /// - Parameter item: The item to remove.
    /// - Returns: `self` after removing all instances of item.
    @discardableResult
    public mutating func removeAll(_ item: Element) -> Self {
        removeAll { $0 == item }
        return self
    }
    /// Remove all instances of multiple items simultaneously from a collection.
    ///
    /// - Parameter items: An array of items to remove.
    /// - Returns: `self` after remove all instances of all items in the given array.
    @discardableResult
    public mutating func removeAll(_ items: Self) -> Self {
        guard !items.isEmpty else { return self }
        removeAll { items.contains($0) }
        return self
    }
    /// Remove all duplicate elements from an array
    ///
    /// - Returns: `self` after duplicate elements have been removed.
    @discardableResult
    public mutating func removeDuplicates() -> Self {
        self = withoutDuplicates()
        return self
    }
    /// Create a new array without duplicate elements.
    ///
    /// - Returns: An array of unique elements.
    public func withoutDuplicates() -> Self {
        return reduce(into: Self()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
    }
    /// Returns an array with all duplicate elements removed using a key path to compare.
    ///
    /// - Parameter path: The key path to compare. The value at this path must conform to `Equatable`.
    /// - Returns: An array of unique elements.
    public func withoutDuplicates <T: Equatable>(keyPath path: KeyPath<Element, T>) -> Self {
        reduce(into: Self()) { partialResult, element in
            if !partialResult.contains(where: { $0[keyPath: path] == element[keyPath: path] }) {
                partialResult.append(element)
            }
        }
    }
    /// Returns an array with all duplicate elements removed using a key path to compare.
    ///
    /// - Parameter path: The key path to compare. The value at this path must conform to `Hashable`.
    /// - Returns: An array of unique elements.
    public func withoutDuplicates <T: Hashable>(keyPath path: KeyPath<Element, T>) -> Self {
        var set = Set<T>()
        return filter { set.insert($0[keyPath: path]).inserted }
    }
}

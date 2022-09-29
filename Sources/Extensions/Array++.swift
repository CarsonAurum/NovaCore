//
// Created by Carson Rau on 1/26/22.
//

import struct Swift.Array
import protocol Swift.Hashable
import class Swift.KeyPath
import protocol Swift.Equatable
import struct Swift.String
import struct Swift.UnsafePointer
import struct Swift.Set

extension Array {
    /// Insert an element at the beginning of an array.
    ///
    /// - Postcondition: `newElement` is the first element in `self`.
    /// - Parameter newElement: Element to insert
    public mutating func prepend(_ newElement: Element) {
        insert(newElement, at: 0)
    }
    /// Safely swap values at given index positions.
    ///
    /// - Note: This method checks to ensure that the given indices are not equal, and that both indices are within the array bounds
    /// before executing the swap. If any of the conditions fail, the method returns silently.
    /// - Postcondition: If the parameters given are valid, the elements at the given indexes are swapped in place.
    /// - Postcondition: If the parameters given are invalid, the array is unchanged.
    /// - Parameters:
    ///   - index: Index of the first element.
    ///   - otherIndex: Index of the other element.
    public mutating func safeSwap(from index: Index, to otherIndex: Index) {
        guard index != otherIndex else { return }
        guard startIndex ..< endIndex ~= index else { return }
        guard startIndex ..< endIndex ~= otherIndex else { return }
        swapAt(index, otherIndex)
    }
    /// Sort an array like another array based on a key path.
    ///
    /// - Note: If the other array doesn't contain a certain value, it will be sorted last.
    /// - Parameters:
    ///   - otherArray: Array of elements in the desired order.
    ///   - keyPath: Key path indicating the property that the array should be sorted by.
    /// - Returns: The sorted array.
    public func sorted <T:Hashable>(
            like otherArray: [T],
            keyPath: KeyPath<Element, T>
    ) -> [Element] {
        let dict = otherArray.enumerated().reduce(into: [:]) {
            $0[$1.element] = $1.offset
        }
        return sorted {
            guard let thisIdx = dict[$0[keyPath: keyPath]] else { return false }
            guard let nextIdx = dict[$1[keyPath: keyPath]] else { return true }
            return thisIdx < nextIdx
        }
    }
}

// MARK: - Conditional Conformances

extension Array where Element: Equatable {
    /// Remove all instances of an item from an array.
    ///
    /// - Parameter item: The item to remove.
    /// - Returns: `self` after removing all instances of item.
    @discardableResult
    public mutating func removeAll(_ item: Element) -> [Element] {
        removeAll { $0 == item }
        return self
    }
    /// Remove all instances of multiple items simultaneously from an array.
    ///
    /// - Parameter items: An array of items to remove.
    /// - Returns: `self` after remove all instances of all items in the given array.
    @discardableResult
    public mutating func removeAll(_ items: [Element]) -> [Element] {
        guard !items.isEmpty else { return self }
        removeAll { items.contains($0) }
        return self
    }
    /// Remove all duplicate elements from an array
    ///
    /// - Returns: `self` after duplicate elements have been removed.
    @discardableResult
    public mutating func removeDuplicates() -> [Element] {
        self = withoutDuplicates()
        return self
    }
    /// Create a new array without duplicate elements.
    ///
    /// - Returns: An array of unique elements.
    public func withoutDuplicates() -> [Element] {
        return reduce(into: [Element]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
    }
    /// Returns an array with all duplicate elements removed using a key path to compare.
    ///
    /// - Parameter path: The key path to compare. The value at this path must conform to `Equatable`.
    /// - Returns: An array of unique elements.
    public func withoutDuplicates <T: Equatable>(keyPath path: KeyPath<Element, T>) -> [Element] {
        reduce(into: [Element]()) { partialResult, element in
            if !partialResult.contains(where: { $0[keyPath: path] == element[keyPath: path] }) {
                partialResult.append(element)
            }
        }
    }
    /// Returns an array with all duplicate elements removed using a key path to compare.
    ///
    /// - Parameter path: The key path to compare. The value at this path must conform to `Hashable`.
    /// - Returns: An array of unique elements.
    public func withoutDuplicates <T: Hashable>(keyPath path: KeyPath<Element, T>) -> [Element] {
        var set = Set<T>()
        return filter { set.insert($0[keyPath: path]).inserted }
    }
}
/*
extension Array where Element == String {
    public static func from(pointer: UnsafePointer<CChar>, n: Int) -> [String] {
        var ptr = pointer
        var result = [String]()
        (0 ..< n).forEach { _ in
            result += .init(cString: ptr)
            ptr = ptr.advance(to: 0).advanced(by: 1)
        }
        return result
    }
}
*/

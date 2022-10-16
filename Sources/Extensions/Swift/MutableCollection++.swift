//
//  Created by Carson Rau on 10/12/22.
//

public extension MutableCollection {
    /// Safely swap values at given index positions.
    ///
    /// - Note: This method checks to ensure that the given indices are not equal, and that both indices are within the array bounds
    /// before executing the swap. If any of the conditions fail, the method returns silently.
    /// - Postcondition: If the parameters given are valid, the elements at the given indexes are swapped in place.
    /// - Postcondition: If the parameters given are invalid, the array is unchanged.
    /// - Parameters:
    ///   - index: Index of the first element.
    ///   - otherIndex: Index of the other element.
    mutating func safeSwap(from index: Index, to otherIndex: Index) {
        guard index != otherIndex else { return }
        guard startIndex ..< endIndex ~= index else { return }
        guard startIndex ..< endIndex ~= otherIndex else { return }
        swapAt(index, otherIndex)
    }
}

extension MutableCollection where Self: RandomAccessCollection {
    public mutating func sort<Value>(
        by keyPath: KeyPath<Self.Element, Value>,
        using valuesAreInIncreasingOrder: (Value, Value) throws -> Bool)
        rethrows {
            self = try sorted(by: keyPath, using: valuesAreInIncreasingOrder)
    }
    
    public mutating func sort<Value: Comparable>(
        by keyPath: KeyPath<Self.Element, Value>) {
        self = sorted(by: keyPath, using: <)
    }
}

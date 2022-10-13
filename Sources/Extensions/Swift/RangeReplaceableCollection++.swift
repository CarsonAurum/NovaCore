//
//  Created by Carson Rau on 10/13/22.
//

//
// Created by Carson Rau on 3/1/22.
//

// MARK: - Constructors

public extension RangeReplaceableCollection {
    /// Construct an empty `RangeReplaceableCollection` prepared to store the specified capacity.
    ///
    /// - Parameter capacity: The number of elements expected in this collection.
    @inlinable
    init(capacity: Int) {
        self.init()
        reserveCapacity(capacity)
    }
}

// MARK: - Replace

public extension RangeReplaceableCollection {
    /// Replace a single element in the collection at a given index with a single element.
    ///
    /// - Parameters:
    ///   - index: The index to conduct the replace operation. The element previously at this index will
    ///            removed.
    ///   - replacement: The new element to insert into the collection.
    /// - Returns: The removed element.
    @discardableResult
    mutating func replace(at index: Index, with replacement: Element) -> Element {
        insert(replacement, at: index)
        return remove(at: self.index(index, offsetBy: 1))
    }
    /// Replace a single element in the collection at a given index with another collection.
    ///
    /// - Parameters:
    ///   - index: The index to conduct the replace operation. The element previously at this index
    ///            will be removed.
    ///   - replacements: A collection of elements whose contents should be inserted starting at the
    ///                   given index.
    /// - Returns: The removed element.
    @discardableResult
    mutating func replace<A:Collection>(
            at index: Index,
            with replacements: A
    ) -> Element where A.Element == Element {
        let oldCount = count
        insert(contentsOf: replacements, at: index)
        return remove(at: self.index(index, offsetBy: (count - oldCount)))
    }
    /// Replace multiple elements in the collection at different indices with a single element.
    ///
    /// - Parameters:
    ///   - indices: The indices where elements should be replaced.
    ///   - replacement: The value to insert at each index.
    /// - Returns: An array containing all elements removed from the collection.
    @discardableResult
    mutating func replace<A:Sequence>(
            at indices: A,
            with replacement: Element
    ) -> [Element] where A.Element == Index {
        indices.map {
            insert(replacement, at: $0)
            return remove(at: self.index($0, offsetBy: 1))
        }
    }
    /// Replace multiple elements in the collection at different indices with another collection.
    /// The removed elements are placed in a secondary collection.
    ///
    /// - Parameters:
    ///   - indices: The indices where the replacement operation should occur.
    ///   - replacements: A collection of replacements to be inserted at each index.
    ///   - sink: A reference to an empty ExtendableSequence to store the removed elements.
    ///
    /// - Postcondition: The `sink` parameter is populated with all removed elements.
    @inlinable
    mutating func replace<A: Sequence, B: Sequence, C: ExtendableSequence>(
            at indices: A,
            with replacements: B,
            removedInto sink: inout C
    ) where A.Element == Index, B.Element == Element, C.Element == Element {
        let replacements = Array(replacements)
        var indexOffset: Int = 0
        for index in indices {
            insert(contentsOf: replacements, at: index)
            indexOffset += replacements.count - 1
            sink += remove(at: self.index(index, offsetBy: indexOffset + 1))
        }
    }
    /// Replace multiple elements in the collection at different indices with the elements of another
    /// collection.
    ///
    /// - Parameters:
    ///   - indices: The indices where the replacement operation should occur.
    ///   - replacements: A collection of replacement items to be inserted at each index.
    /// - Returns: An array containing all removed elements from the collection.
    @discardableResult
    mutating func replace<A: Sequence, B: Sequence>(
            at indices: A,
            with replacements: B
    ) -> [Element] where A.Element == Index, B.Element == Element {
        var result: [Element] = []
        replace(at: indices, with: replacements, removedInto: &result)
        return result
    }
    /// Replace elements that match a given predicate with a replacement element.
    ///
    /// - Parameters:
    ///   - predicate: The predicate function to use to determine which items should be replaced.
    ///   - replacement: The element to swap in.
    /// - Returns: An array containing all removed elements from the collection.
    @discardableResult
    mutating func replace(_ predicate: (Element) -> Bool, with replacement: Element) -> [Element] {
        replace(at: indices.filter { predicate(self[$0]) }, with: replacement)
    }
    /// Replace elements that match a given predicate with the contents of another collection.
    ///
    /// - Parameters:
    ///   - predicate: The predicate function to use to determine which items should be replaced.
    ///   - replacements: The collection of elements to add at each index matching the predicate.
    /// - Returns: An array containing all elements removed from the collection.
    @discardableResult
    mutating func replace<A: Collection>(
            _ predicate: (Element) -> Bool,
            with replacements: A
    ) -> [Element] where A.Element == Element {
        replace(at: indices.filter { predicate(self[$0]) }, with: replacements)
    }
    mutating func replaceSubranges<A: Collection, B: Collection, C: Collection>(
            _ subranges: A,
            with replacements: B
    ) where A.Element == Range<Index>, B.Element == C, C.Element == Element {
        assert(subranges.count == replacements.count)
        guard !subranges.isEmpty else { return }
        guard subranges.count != 1 else {
            return replaceSubrange(
                subranges.first.forceUnwrap(),
                with: replacements.first.forceUnwrap()
            )
        }
        let sorted = subranges
            .zip(replacements)
            .sorted(by: { $0.0 <~= $1.0})
            .lazy.map { ($0.0, Optional.some($0.1)) }
        let first = sorted.first.forceUnwrap()
        let last = sorted.last.forceUnwrap()
        sorted.consecutives().forEach {
            if $0.0.0.upperBound > $0.1.0.lowerBound {
                fatalError("Input ranges may not overlap!")
            }
        }
        let sortedWithGaps = CollectionOfOne(first).join(
            sorted
                .consecutives()
                .map { [($0.0.0.upperBound ..< $0.1.0.lowerBound, nil), ($0.1.0, $0.1.1)] }
                .joined()
        )
        var sortedWithGapsAndEnd = sortedWithGaps.join([])
        if last.0.upperBound < endIndex {
            sortedWithGapsAndEnd = sortedWithGaps.join([(last.0.upperBound..<endIndex, nil)])
        }
        let empty: [(Range<Index>, C?)] = []
        var sortedWithGapsAndStart = empty.join(sortedWithGapsAndEnd)
        if first.0.lowerBound > startIndex {
            let joiner: [(Range<Index>, C?)] = [(startIndex..<first.0.lowerBound, nil)]
            sortedWithGapsAndStart = joiner.join(sortedWithGapsAndEnd)
        }
        var newSelf = Self.init(capacity: 0)
        sortedWithGapsAndStart.forEach { range, replacement in
            replacement
                    .map { newSelf.append(contentsOf: $0) }
                    .onNone { newSelf.append(contentsOf: self[range]) }
        }
        self = newSelf
    }
    func replacingSubranges<A: Collection, B: Collection, C: Collection>(
            _ subranges: A,
            with replacements: B
    ) -> Self where A.Element == Range<Index>, B.Element == C, C.Element == Element {
        var result = self
        result.replaceSubranges(subranges, with: replacements)
        return result
    }
}
// MARK: - Remove
public extension RangeReplaceableCollection {
    /// Attempt to remove an element at an index if that index is present.
    ///
    /// - Parameter index: The index to attempt removal.
    /// - Returns: The removed element, or nil if no element is removed.
    @discardableResult
    mutating func tryRemove(at index: Index) ->  Element? {
        indices.contains(index) ? remove(at: index) : nil
    }
    /// Attempt to remove a range of indices if that range is within the bounds of this collection.
    ///
    /// - Parameter bounds: The range of indices to attempt removal.
    mutating func tryRemoveSubrange(_ bounds: Range<Index>) {
        if contains(bounds) {
            removeSubrange(bounds)
        }
    }
    @discardableResult
    mutating func tryRemoveFirst() -> Element? {
        isEmpty ||-> removeFirst()
    }
    @discardableResult
    func tryingRemoveFirst() -> Self {
        self |> { $0.tryRemoveFirst() }
    }
    @discardableResult
    mutating func tryRemoveLast() -> Element? {
        isEmpty ||-> remove(at: lastIndex)
    }
    @discardableResult
    func tryingRemoveLast() -> Self {
        self |> { $0.tryRemoveLast() }
    }
    @discardableResult
    mutating func remove(at first: Index, _ second: Index, _ rest: Index...) -> [Element] {
        remove(at: [first,second] + rest)
    }
    @discardableResult
    func removing(at index: Index) -> Self {
        self |> { $0.remove(at: index) }
    }
    mutating func remove<A: Sequence, B: ExtendableSequence>(
            at indices: A,
            into result: inout B
    ) where A.Element == Index, B.Element == Element {
        var offset: Int = 0
        for idx in indices {
            result += self.remove(at: self.index(idx, offsetBy: -offset))
            offset.advance()
        }
    }
    @discardableResult
    mutating func remove<A: Sequence>(at indices: A) -> [Element] where A.Element == Index {
        var result: [Element] = []
        remove(at: indices, into: &result)
        return result
    }
    @discardableResult
    func removing<A: Sequence>( at indices: A) -> Self where A.Element == Index {
        self |> { $0.remove(at: indices) }
    }
    mutating func remove<A: Collection, B: ExtendableCollection>(
            at indices: A,
            into result: inout B
    ) where A.Element == Index, B.Element == Element {
        remove(at: AnySequence(indices), into: &result)
    }
    @discardableResult
    mutating func remove<A: Collection>( at indices: A) -> [Element] where A.Element == Index {
        var result: [Element] = .init(capacity: indices.count)
        remove(at: indices, into: &result)
        return result
    }
    @discardableResult
    func removing<A: Collection>(at indices: A) -> Self where A.Element == Index {
        update(self, { $0.remove(at: indices) })
    }
    mutating func remove(_ predicate: (Element) -> Bool) {
        var indices: [Index] = []
        for (idx, element) in enumerated() {
            predicate(element) &&-> (indices += idx)
        }
        remove(at: indices)
    }
    @discardableResult
    func removing(_ predicate: (Element) -> Bool) -> Self {
        var result = self
        result.remove(predicate)
        return result
    }
}

// MARK: - Insert

public extension RangeReplaceableCollection {
    mutating func insert(_ element: Element, at index: RelativeIndex)  {
        insert(element, at: self.index(atDistance: index.distanceFromStart))
    }
    mutating func insert<A:Collection>(contentsOf collection: A, at index: RelativeIndex)
    where A.Element == Element {
        insert(contentsOf: collection, at: self.index(atDistance: index.distanceFromStart))
    }
}

// MARK: - Conditional Conformance

extension RangeReplaceableCollection where Element: Equatable {
    @discardableResult
    public mutating func replace(allOf element: Element, with replacement: Element) -> [Element] {
        replace(at: indices.filter{ self[$0] == element}, with: replacement)
    }
    @discardableResult
    public mutating func replace<A: Collection>(
            allOf element: Element,
            with replacements: A
    ) -> [Element] where A.Element == Element {
        replace(at: indices.filter { self[$0] == element }, with: replacements)
    }
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
extension RangeReplaceableCollection where Element: Identifiable {
    public mutating func upsert(_ element: Element) {
        if let idx = firstIndex(where: { $0.id == element.id }) {
            replace(at: idx, with: element)
        } else {
            insert(element, at: 0)
        }
    }
    public mutating func upsert<A: Sequence>(contentsOf elements: A) where A.Element == Element {
        elements.forEach { upsert($0) }
    }
    public mutating func updateOrAppend(_ element: Element) {
        if let idx = firstIndex(where: { $0.id == element.id}) {
            replace(at: idx, with: element)
        } else {
            append(element)
        }
    }
    public mutating func updateOrAppend<A:Sequence>(contentsOf elements: A) where A.Element == Element {
        elements.forEach { updateOrAppend($0) }
    }
}

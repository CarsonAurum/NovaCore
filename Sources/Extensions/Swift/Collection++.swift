//
// Created by Carson Rau on 1/31/22.
//

public extension Collection {
    /// Access the bounds of this collection as a range.
    @inlinable
    var bounds: Range<Index> { startIndex ..< endIndex }
    /// Map each index to its distance from the first index in the collection.
    @inlinable
    var distances: LazyMapCollection<Indices, Int> { indices.lazy.map(distanceFromStartIndex) }
    @inlinable
    var fullRange: Range<Index> { startIndex ..< endIndex }
    @inlinable
    var lastIndex: Index { try! indices.last.unwrap() }
    /// The length of the collection.
    @inlinable
    var length: Int { distance(from: startIndex, to: endIndex) }
}

public extension Collection {
    func consecutives() -> AnySequence<(Element, Element)> {
        guard !isEmpty else { return .init([]) }
        func makeIterator() -> AnyIterator<(Element, Element)> {
            var idx = startIndex
            return AnyIterator {
                let nextIdx = self.index(after: idx)
                guard nextIdx  < self.endIndex else { return nil }
                defer { idx = nextIdx }
                return (self[idx], self[nextIdx])
            }
        }
        return .init(makeIterator)
    }
    @inlinable
    func containsIndex(_ index: Index) -> Bool {
        index >= startIndex && index < endIndex
    }
    @inlinable
    func contains(after index: Index) -> Bool {
        containsIndex(index) && containsIndex(self.index(after: index))
    }
    @inlinable
    func contains(_ bounds: Range<Index>) -> Bool {
        containsIndex(bounds.lowerBound) && containsIndex(index(bounds.upperBound, offsetBy: -1))
    }
    @inlinable
    func distanceFromStartIndex(to index: Index) -> Int {
        distance(from: startIndex, to: index)
    }
    @inlinable
    func enumerated() -> LazyMapCollection<Self.Indices, (Self.Index, Self.Element)> {
        indices.lazy.map { ($0, self[$0]) }
    }
    @inlinable
    func index(of predicate: (Element) throws -> Bool) rethrows -> Index? {
        try enumerated().find { try predicate($1) }?.0
    }
    @inlinable
    func index(atDistance distance: Int) -> Index {
        index(startIndex, offsetBy: distance)
    }
    @inlinable
    func index(_ index: Index, insetBy distance: Int) -> Index {
        self.index(index, offsetBy: -distance)
    }
    @inlinable
    func index(_ index: Index, offsetByDistanceFromStartIndexFor otherIndex: Index) -> Index {
        self.index(index,  offsetBy: distanceFromStartIndex(to: otherIndex))
    }
    @inlinable
    func range(from range: Range<Int>) -> Range<Index> {
        index(atDistance: range.lowerBound) ..< index(atDistance: range.upperBound)
    }
}

public extension Collection {
    subscript(atDistance distance: Int) -> Element {
        @inlinable get { self[index(atDistance: distance)] }
    }
    subscript(betweenDistances distance: Range<Int>) -> SubSequence {
        @inlinable get {
            self[index(atDistance: distance.lowerBound) ..< index(atDistance: distance.upperBound)]
        }
    }
    subscript(betweenDistances distance: ClosedRange<Int>) -> SubSequence {
        @inlinable get {
            self[index(atDistance: distance.lowerBound)...index(atDistance: distance.upperBound)]
        }
    }
    subscript(after index: Index) -> Element {
        self[self.index(after: index)]
    }
    subscript(try index: Index) -> Element? {
        @inlinable get { Optional(self[index], if: containsIndex(index)) }
    }
    subscript(try bounds: Range<Index>) -> SubSequence? {
        @inlinable get { Optional(self[bounds], if: contains(bounds)) }
    }
}

// MARK: - Conditional Conformances

extension Collection where Index: Strideable {
    @inlinable
    public var stride: Index.Stride {
        startIndex.distance(to: endIndex)
    }
}

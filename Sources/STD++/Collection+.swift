//
// Created by Carson Rau on 3/3/22.
//
// MARK: - Relative Index
/// A position index for a collection based on the distance from the start position.
///
/// This enables the use of integer indices on collections that do not have an integer index type.
public struct RelativeIndex: ExpressibleByIntegerLiteral {
    /// The number of indices to offset the initial index by to reach this item in the collection.
    public let distanceFromStart: Int
    /// Create a new relative index at a given distance.
    ///
    /// - Parameter distance: The number of elements from the starting index.
    public init(atDistance distance: Int) {
        distanceFromStart = distance
    }
    /// Static factory function to enable the creation of relative indices at a given distance.
    ///
    /// - Parameter distance: The number of elements from the starting index.
    public static func atDistance(_ distance: Int) -> RelativeIndex {
        .init(atDistance: distance)
    }
    /// A conversion initializer to enable the creation of relative indices from the standard index
    /// type of a given collection.
    ///
    /// - Parameters:
    ///   - index: The index of the desired item in the given collection.
    ///   - collection: The collection to operate on.
    public init<A:Collection>(_ index: A.Index, in collection: A) {
        self.init(atDistance: collection.distance(from: collection.startIndex, to: index))
    }
    /// Create a new relative index value with an integer literal.
    ///
    /// - Parameter value: The integer literal to use when initializing this value.
    public init(integerLiteral value: Int) {
        self.init(atDistance: value)
    }
    /// A conversion function to enable the conversion of relative to real indices for a given collection.
    ///
    /// - Parameter collection: The collection to operate on.
    public func absolute<A:Collection>(in collection: A) -> A.Index {
        collection.index(atDistance: distanceFromStart)
    }
}
public extension Collection {
    /// A subscript to enable the accessing of items in a collection by relative index.
    ///
    /// - Parameter index: The relative index to access within this collection.
    subscript(_ index: RelativeIndex) -> Element  {
        self[self.index(atDistance: index.distanceFromStart)]
    }
}
public extension MutableCollection {
    /// A subscript to enable the accessing and setting of items in a collection by relative index.
    subscript(_ index: RelativeIndex) -> Element {
        get {
            lazy.map { $0 }[index]
        }
        set {
            self[self.index(atDistance: index.distanceFromStart)] = newValue
        }
    }
}
// MARK: - Join
/// A "sum" collection type based on two sub collections that are joined in sequential order.
public struct Join2Collection<A: Collection, B: Collection>: Collection
        where A.Index: Strideable, A.Element == B.Element, A.Index == B.Index {
    /// The shared element type.
    public typealias Element = A.Element
    /// The shared index type.
    public typealias Index = A.Index
    /// The joined iterator type.
    public typealias Iterator = Join2Iterator<A.Iterator, B.Iterator>
    /// A value type representing the pair of collections as a tuple.
    public typealias Value = (A, B)
    /// Protected access for the values.
    public private(set) var value: Value
    /// Initialize a new value from a tuple of collections.
    ///
    /// - Parameter value: The value containing the collections to be joined.
    public init(_ value: Value) {
        self.value = value
    }
    /// The position of the first element in a nonempty collection.
    public var startIndex: Index { value.0.startIndex }
    /// The collection’s “past the end” position—that is, the position one greater than the last
    /// valid subscript argument for both collections.
    public var endIndex: Index { value.0.endIndex.advanced(by: value.1.stride) }
    /// Returns an iterator over the elements of the collection.
    /// - Returns: A joined iterator for the elements of this collection.
    public __consuming func makeIterator() -> Iterator {
        .init((value.0.makeIterator(), value.1.makeIterator()))
    }
    /// Access the element at a given index within the joined collection.
    ///
    /// - Parameter index: The index to access.
    /// - Returns: The element at the given index.
    public subscript(index: Index) -> Element {
        if index >= value.0.endIndex {
            return value.1[index.advanced(by: -value.1.stride)]
        }
        return value.0[index]
    }
    /// Returns the position immediately after the given index.
    ///
    /// - Parameter i: A valid index of the joined collection.
    /// - Returns: The index value immediately after the given index.
    public func index(after i: A.Index) -> A.Index {
        i.advanced(by: 1)
    }
}
extension Join2Collection: MutableCollection where A: MutableCollection, B: MutableCollection {
    /// Passthrough mutability subscript for a joined collection.
    ///
    /// - Parameter index: The index within the joined sequence to access.
    /// - Returns: A mutable copy of the element at the given index.
    public subscript(index: Index) -> Element {
        get {
            value.0.lazy.map({ $0 }).join(value.1)[index]
        } set {
            if index >= value.0.endIndex {
                value.1[index.advanced(by: -value.1.stride)] = newValue
            } else {
                value.0[index] = newValue
            }
        }
    }
}
/// A "sum" collection created by joining three collections.
public typealias Join3Collection<A: Collection, B: Collection, C: Collection> = Join2Collection<Join2Collection<A, B>, C>
        where A.Index: Strideable, A.Element == B.Element, B.Element == C.Element, A.Index == B.Index,
              B.Index == C.Index

public extension Collection {
    /// Join this collection with another.
    ///
    /// - Parameter other: The collection to join with self.
    /// - Returns: A new joined "sum" collection with `self` and `other`.
    func join<A: Collection>(_ other: A) -> Join2Collection<Self, A> where A.Element == Element {
        .init((self, other))
    }
    /// Join this collection with two other collections.
    ///
    /// - Parameters:
    ///   - other1: The first collection to join with self.
    ///   - other2: The second collection to join with self.
    /// - Returns: A new joined "sum" collection with `self`, `other1`, and `other2`.
    func join<A: Collection, B: Collection>(_ other1: A, _ other2: B) -> Join3Collection<Self, A, B>
            where A.Element == Element {
        join(other1).join(other2)
    }
}
// MARK: - SequenceToCollection
/// A bridge type to enable the conversion of sequences to full random access collections.
public struct SequenceToCollection<A: Sequence>: RandomAccessCollection {
    /// The seqeuence encapsulated within this wrapper.
    public typealias Value = A
    /// The element stored within the encapsulated sequence.
    public typealias Element = A.Element
    /// The index of the underlying sequence.
    public typealias Index = Int
    /// The multi-index type of the underlying sequence.
    public typealias Indices = CountableRange<Index>
    /// The iterator for the underlying sequence
    public typealias Iterator = Value.Iterator
    
    /// The encapsulated sequence.
    public let value: Value
    /// Create a new collection from a given sequence.
    ///
    /// - Parameter value: The sequence to encapsulate within this collection.
    public init(_ value: Value) { self.value = value }
    /// The start index of this collection.
    public var startIndex: Index { 0 }
    /// The end index of this collection.
    public var endIndex: Index { countElements() }
    /// A collection of all indices within this collection.
    public var indices: Indices { .init(bounds: (startIndex, endIndex)) }
    /// A subscript to access an element wihtin this collection by index.
    ///
    /// - Parameter index: The index whose element should be accessed.
    /// - Returns: The element at the given element.
    public subscript(index: Index) -> Element {
        value.dropFirst(index).first.forceUnwrap()
    }
    /// Access the iterator from this collection.
    public __consuming func makeIterator() -> Iterator {
        value.makeIterator()
    }
}
public extension Sequence {
    /// Quick conversion from sequence to random access collection.
    ///
    /// - Returns: A bridged collection type based on this sequence.
    func toAnyCollection() -> SequenceToCollection<Self> {
        .init(self)
    }
}

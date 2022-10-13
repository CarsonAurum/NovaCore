//
// Created by Carson Rau on 3/3/22.
//

// MARK: - PredicateSequencePrefix
/// A sequence created to store the first section of a larger sequence until the first element instance that satisfies a given predicate.
public struct PredicateSequencePrefix<A: Sequence>: Sequence {
    /// The elements that can be stored within this type.
    public typealias Element = A.Element
    private var base: A
    /// The predicate.
    public let isTerminator: (Element) -> Bool
    /// Create a new predicated sequence prefix from a base sequence and a given terminator predicate.
    /// - Parameters:
    ///   - base: The base sequence
    ///   - isTerminator: The terminator predicate to use when testing for the last desired value in the prefix.
    public init(_ base: A, isTerminator: @escaping (Element) -> Bool) {
        self.base = base
        self.isTerminator = isTerminator
    }
    /// The iterator for this type.
    public struct Iterator: IteratorProtocol {
        private var base: A.Iterator
        /// The predicate for the sequence being iterated over.
        public let isTerminator: (Element) -> Bool
        /// Create a new iterator from the given base iterator type and the desired predicate.
        /// - Parameters:
        ///   - base: The base iterator.
        ///   - isTerminator: The terminator predicate to use when testing for the last desired value in the prefix.
        public init(_ base: A.Iterator, isTerminator: @escaping (Element) -> Bool) {
            self.base = base
            self.isTerminator = isTerminator
        }
        /// Access the next element via iterator.
        /// - Returns: The next element.
        public mutating func next() -> Element? {
            base.next().filter { !isTerminator($0) }
        }
    }
    /// Access the iterator for this type.
    /// - Returns: The iterator.
    public __consuming func makeIterator() -> Iterator {
        .init(base.makeIterator(), isTerminator: isTerminator)
    }
}

extension Sequence {
    public func prefix(till isTerminator: @escaping (Element) -> Bool) -> PredicateSequencePrefix<Self> {
        .init(self, isTerminator:  isTerminator)
    }
}

extension Sequence where Element: Equatable {
    public func prefix(till element: Element) -> PredicateSequencePrefix<Self> {
        .init(self, isTerminator: { $0 == element })
    }
}

// MARK: - Join
public struct Join2Sequence<A: Sequence, B: Sequence>: Sequence where A.Element == B.Element {
    public typealias Value = (A, B)
    public typealias Element = A.Element
    public private(set) var value: Value
    public init(_ value: Value)  {
        self.value = value
    }
    public __consuming func makeIterator() -> Join2Iterator<A.Iterator, B.Iterator> {
        .init((value.0.makeIterator(), value.1.makeIterator()))
    }
}

public extension Sequence {
    func join<A:Sequence>(_ other: A) -> Join2Sequence<Self, A> {
        .init((self, other))
    }
    func join(_ other: Element) -> Join2Sequence<Self, CollectionOfOne<Element>> {
        join(.init(other))
    }
}

// MARK: - SequenceFactory
public protocol SequenceFactory: Sequence {
    init(noSequence: Void)
    init<A: Sequence>(_: A) where A.Element == Element
}
extension SequenceFactory {
    public init(noSequence: Void) {
        self.init(EmptyCollection())
    }
}
// MARK: Conformance
extension AnyCollection: SequenceFactory {
    public init<A>(_ sequence: A) where A: Sequence, Element == A.Element {
        self.init(sequence.toAnyCollection())
    }
}
extension AnySequence: SequenceFactory { }
extension Array: SequenceFactory { }
extension Dictionary: SequenceFactory {
    public init<A>(_ sequence: A) where A: Sequence, (key: Key, value: Value) == A.Element {
        self.init()
        append(contentsOf: sequence)
    }
}
extension Set: SequenceFactory { }
extension String: SequenceFactory { }
extension Substring: SequenceFactory { }

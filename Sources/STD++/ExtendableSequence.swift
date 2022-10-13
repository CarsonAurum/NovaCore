//
// Created by Carson Rau on 3/2/22.
//

/// A type representing a sequence that can be extended via insertion or appending.
public protocol ExtendableSequence: Sequence {
    /// Single element insertion operation result type.
    associatedtype ElementInsertType = Void
    /// Single element append operation result type.
    associatedtype ElementAppendType = Void
    /// Multiple element insertion operation result type.
    associatedtype ElementsInsertType = Void
    /// Multiple element append operation result type.
    associatedtype ElementsAppendType = Void
    
    /// Insert a single element at the start of this sequence.
    ///
    /// - Parameter _: The element to prepend.
    /// - Returns: The result of this operation.
    @discardableResult
    mutating func insert(_: Element) -> ElementInsertType
    /// Insert a sequence of elements at the start of this sequence.
    ///
    /// - Parameter _: The sequence whose contents will be prepended.
    /// - Returns: The result of this operation.
    @discardableResult
    mutating func insert<A:Sequence>(contentsOf _: A) -> ElementsInsertType where A.Element == Element
    /// Insert a collection of elements at the start of this sequence.
    ///
    /// - Parameter _: The collection whose contents will be prepended.
    /// - Returns: The result of this operation.
    @discardableResult
    mutating func insert<A:Collection>(contentsOf _: A) -> ElementsInsertType where A.Element == Element
    /// Insert a bidirectional collection of elements at the start of this sequence.
    ///
    /// - Parameter _: The bidirectional collection whose contents will be prepended.
    /// - Returns: The result of this operation.
    @discardableResult
    mutating func insert<A:BidirectionalCollection>(contentsOf _: A) -> ElementsInsertType where A.Element == Element
    /// Insert a random access collection of elements at the start of this sequence.
    ///
    /// - Parameter _: The random access collection whose contents will be prepended.
    /// - Returns: The result of this operation.
    @discardableResult
    mutating func insert<A:RandomAccessCollection>(contentsOf _: A) -> ElementsInsertType where A.Element == Element
    /// Insert a single element at the end of this sequence.
    ///
    /// - Parameter _: The element to append.
    /// - Returns: The result of this operation.
    @discardableResult
    mutating func append(_: Element) -> ElementAppendType
    /// Insert a sequence of elements at the end of this sequence.
    ///
    /// - Parameter _: The sequence whose contents will be appended.
    /// - Returns: The result of this operation.
    @discardableResult
    mutating func append<A:Sequence>(contentsOf _: A) -> ElementsAppendType where A.Element == Element
    /// Insert a collection of elements at the end of this sequence.
    ///
    /// - Parameter _: The collection whose contents will be appended.
    /// - Returns: The result of this operation.
    @discardableResult
    mutating  func append<A:Collection>(contentsOf _: A) -> ElementsAppendType where A.Element == Element
    /// Insert a bidirectional collection of elements at the end of this sequence.
    ///
    /// - Parameter _: The bidirectional collection whose contents will be appended.
    /// - Returns: The result of this operation.
    @discardableResult
    mutating func append<A:BidirectionalCollection>(contentsOf _: A) -> ElementsAppendType where A.Element == Element
    /// Insert a random access collection of elements at the end of this sequence.
    ///
    /// - Parameter _: The random access collection whose contents will be appended.
    /// - Returns: The result of this operation.
    @discardableResult
    mutating func append<A:RandomAccessCollection>(contentsOf _: A) -> ElementsAppendType where A.Element == Element
}
/// A type representing a collection that can be extended via insertion or appending.
public protocol ExtendableCollection: Collection, ExtendableSequence { }

/// A type representing a range replaceable collection that can be extended via insertion or appending.
public protocol ExtendableRangeReplaceableCollection: ExtendableCollection, RangeReplaceableCollection { }

// MARK: - Implementation
extension ExtendableSequence where ElementsAppendType == Void {
    public mutating func append<A:Sequence>(contentsOf newElements: A) where A.Element == Element {
        newElements.forEach { self.append($0) }
    }
}
extension ExtendableSequence where ElementsInsertType == Void {
    public mutating func insert<A:Sequence>(contentsOf newElements: A) where A.Element == Element {
        newElements.reversed().forEach { self.insert($0) }
    }
    public mutating func insert<A:Collection>(contentsOf newElements: A) where A.Element == Element {
        newElements.reversed().forEach { self.insert($0) }
    }
    public mutating func insert<A:Collection>(contentsOf newElements: A)
            where A.Element == Element, A.Index: Strideable {
        newElements.reversed().forEach { self.insert($0) }
    }
}
extension ExtendableRangeReplaceableCollection where ElementInsertType == Void {
    public mutating func insert(_ newElement: Element) {
        insert(newElement, at: startIndex)
    }
}
// MARK: - Extensions
public extension ExtendableSequence {
    /// Chainable insertion function for a single element.
    ///
    /// - Parameter newElement: The new element to insert.
    /// - Returns: `self` after the operation.
    func inserting(_ newElement: Element) -> Self {
        self |> { $0.insert(newElement) }
    }
    /// Chainable insertion function for a sequence of elements.
    ///
    /// - Parameter newElements: The sequence of elements to insert.
    /// - Returns: `self` after the operation.
    func inserting<A:Sequence>(contentsOf newElements: A) -> Self where A.Element == Element {
        self |> { $0.insert(contentsOf: newElements) }
    }
    /// Chainable append function for a single element.
    ///
    /// - Parameter newElement: The new element to append.
    /// - Returns: `self` after the operation.
    func appending(_ newElement: Element) -> Self {
        self |> { $0.append(newElement) }
    }
    /// Chainable append function for a sequence of elements.
    ///
    /// - Parameter newElements: The sequence of elements to append.
    /// - Returns: `self` after the operation.
    func appending<A:Sequence>(contentsOf newElements: A) -> Self where A.Element == Element {
        self |> { $0.append(contentsOf: newElements) }
    }
}
// MARK: - Operators
public extension ExtendableSequence {
    static func +(lhs: Element, rhs: Self) -> Self {
        rhs.inserting(lhs)
    }
    static func +(lhs: Self, rhs: Element) -> Self {
        lhs.appending(rhs)
    }
    static func +=(lhs: inout Self, rhs: Element) {
        lhs.append(rhs)
    }
    static func +<A:ExtendableSequence>(lhs: Self, rhs: A) -> Self where A.Element == Element {
        lhs.appending(contentsOf: rhs)
    }
    static func +=<A:ExtendableSequence>(lhs: inout Self, rhs: A) where A.Element == Element {
        lhs.append(contentsOf: rhs)
    }
}
public extension ExtendableRangeReplaceableCollection {
    static func +(lhs: Element, rhs: Self) -> Self {
        rhs.inserting(lhs)
    }
    static func +(lhs: Self, rhs: Element) -> Self {
        lhs.appending(rhs)
    }
    static func +=(lhs: inout Self, rhs: Element) {
        lhs.append(rhs)
    }
    static func +<A:Sequence>(lhs: A, rhs: Self) -> Self where A.Element == Element {
        rhs.inserting(contentsOf: lhs)
    }
    static func +<A:Sequence>(lhs: Self, rhs: A) -> Self where A.Element == Element {
        lhs.appending(contentsOf: rhs)
    }
    static func +=<A:Sequence>(lhs: inout Self, rhs: A) where A.Element == Element {
        lhs.append(contentsOf: rhs)
    }
    static func +<A:ExtendableRangeReplaceableCollection>(lhs: Self, rhs: A) -> Self
            where A.Element == Element {
        lhs.appending(contentsOf: rhs)
    }
    static func +=<A:ExtendableRangeReplaceableCollection>(lhs: inout Self, rhs: A)
            where A.Element == Element {
        lhs.append(contentsOf: rhs)
    }
}

// MARK: - Protocol Conformances

extension Array: ExtendableSequence {
    public mutating func insert(_ newElement: Element) {
        insert(newElement, at: 0)
    }
}
extension Dictionary: ExtendableSequence {
    public mutating func insert(_ newElement: Element) {
        append(newElement)
    }
    public mutating func append(_ newElement: Element) {
        self[newElement.0] = newElement.1
    }
    public mutating func append <S:Sequence>(contentsOf newElements: S) where S.Element == Element {
        newElements.forEach { self.append($0) }
    }
}
extension String: ExtendableSequence {
    public mutating func insert(_ newElement: Element) {
        insert(newElement, at: startIndex)
    }
}
extension Set: ExtendableSequence {
    public mutating func append(_ newElement: Element) {
        insert(newElement)
    }
}
extension String.UnicodeScalarView: ExtendableRangeReplaceableCollection { }

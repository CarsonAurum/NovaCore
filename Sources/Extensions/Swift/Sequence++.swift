//
//  Created by Carson Rau on 3/1/22.
//

public extension Sequence {
    /// Quick access to the first element in the sequence. If no elements are present in the sequence,
    /// this is nil.
    @inlinable
    var first: Element? {
        for element in self {
            return element
        }
        return nil
    }
    /// Flag to determine if the sequence contains any values.
    @inlinable
    var isEmpty: Bool { first == nil }
    /// Quick access to the last element in the sequence. If no elements are present in the sequence,
    /// this is nil.
    @inlinable
    var last: Element? {
        var result: Element?
        for element in self {
            result = element
            
        }
        return result
    }
}

public extension Sequence {
    /// Check if all elements in collection match a condition.
    ///
    /// - Parameter condition: condition to evaluate each element against.
    /// - Returns: true when all elements in the array match the specified condition.
    func all(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        try !contains { try !condition($0) }
    }
    /// Access a portion of a given sequence by start and end index.
    ///
    /// - Parameters:
    ///   - startIndex: The index to start the desired range.
    ///   - endIndex: The index to end the desired range.
    /// - Returns: A subsequence containing all elements between the indices provided.
    func between(
        count startIndex: Int,
        and endIndex: Int
    ) -> PrefixSequence<DropFirstSequence<Self>> {
        dropFirst(startIndex).prefix(endIndex - startIndex)
    }
    /// Count elements by iterator.
    /// - Returns: The number of elements currently in this sequence.
    func countElements() -> Int {
        var count = 0
        for _ in self {
            count += 1
        }
        return count
    }
    /// Access the elements with a shared value at the given key path.
    ///
    /// - Parameter groupedBy: The keypath to check for duplicate values.
    /// - Returns: A dictionary containing each array of duplicate elements keyed by the value they share in common.
    func duplicates<T: Hashable>(groupedBy keyPath: KeyPath<Element, T>) -> [T: [Element]] {
        .init(grouping: self, by: { $0[keyPath: keyPath] }).filter { $1.count > 1 }
    }
    /// Access an element at a specific count into the iterator for this sequence.
    ///
    /// - Parameter count: The number of elements to iterate before returning.
    /// - Returns: The element at the given count, if it exists, `nil` otherwise.
    func element(atCount count: Int) -> Element? {
        dropFirst(count).last
    }
    /// Access an element at a specific count from the end of the iterator for this sequence.
    ///
    /// - Parameter count: The number of elements to iterate from the end of the sequence before returning.
    /// - Returns: The element at the given offset from the end of the sequence, if it exists, `nil` otherwise.
    func element(atReverseCount count: Int) -> Element? {
        dropLast(count).last
    }
    func element(before predicate: (Element) throws -> Bool) rethrows -> Element? {
        var last: Element?
        for element in self {
            if try predicate(element) {
                return last
            }
            last = element
        }
        return nil
    }
    func element(after predicate: (Element) throws -> Bool) rethrows -> Element? {
        var returnNext: Bool = false
        for element in self {
            if returnNext {
                return element
            }
            if try predicate(element) {
                returnNext = true
            }
        }
        return nil
    }
    func elements(
            between firstPredicate: (Element) throws -> Bool,
            and lastPredicate: (Element) throws -> Bool
    ) rethrows -> [Element] {
        var first: Element?
        var result: [Element] = []
        for element in self {
            if try firstPredicate(element) && first == nil {
                first = element
            } else if try lastPredicate(element) {
                return result
            } else if first != nil {
                result += element
            }
        }
        return []
    }
    @inlinable
    func find<T, U>(_ iterator: (_ take: (T) -> Void, _ element: Element) throws -> U) rethrows -> T? {
        var result: T? = nil
        var stop: Bool = false
        for element in self {
            _ = try iterator({ stop = true; result = $0}, element)
            if stop { break }
        }
        return result
    }
    func find(_ predicate: (Element) throws -> Bool) rethrows -> Element? {
        try find { take, element in try predicate(element) &&-> take(element) }
    }
    func group<T: Hashable>(by identify: (Element) throws -> T) rethrows -> [T: [Element]] {
        var result: [T: [Element]] = .init(minimumCapacity: underestimatedCount)
        for element in self {
            result[try identify(element), default: []].append(element)
        }
        return result
    }
    /// Check if no elements in collection match a condition.
    ///
    /// - Parameter condition: condition to evaluate each element against.
    /// - Returns: true when no elements in the array match the specified condition.
    func none(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        try !contains { try condition($0) }
    }
    func optionalFilter<T>(_ predicate: (T) throws -> Bool) rethrows -> [T?] where Element == T? {
        try filter { try $0.map(predicate) ?? true }
    }
    func optionalMap<T, U>(_ transform: (T) throws -> U) rethrows -> [U?] where Element == T? {
        try map { try $0.map(transform) }
    }
    @inlinable
    func reduce(_ combine: (Element, Element) -> Element) -> Element? {
        var result: Element! = nil
        for element in self {
            guard result != nil else { result = element; continue }
            result = combine(result, element)
        }
        return result
    }
    @inlinable
    func reduce<T>(_ initial: T, _ combine: (T) throws -> (Element) -> T) rethrows -> T {
        try reduce(initial) { try combine($0)($1) }
    }
    @inlinable
    func reduce<T: ExpressibleByNilLiteral>(_ combine: (T) throws -> (Element) -> T) rethrows -> T {
        try reduce(nil) { try combine($0)($1) }
    }
    @inlinable
    func reduce<T: ExpressibleByNilLiteral>(_ combine: (T, Element) throws -> T) rethrows -> T {
        try reduce(nil, combine)
    }
    func separated(by separator: Element) -> AnySequence<Element> {
        guard let first = first else { return .init(noSequence: ()) }
        return .init(
                CollectionOfOne(first)
                    .join(dropFirst().flatMap {
                            CollectionOfOne(separator).join(CollectionOfOne($0))
                        }
                    )
        )
    }
    /// Sort a sequence like another array based on a key path.
    ///
    /// - Note: If the other sequence doesn't contain a certain value, it will be sorted last.
    /// - Parameters:
    ///   - otherArray: Array of elements in the desired order.
    ///   - keyPath: Key path indicating the property that the sequence should be sorted by.
    /// - Returns: The sorted array.
    func sorted <T:Hashable>(
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
    @inlinable
    func zip <S:Sequence>(_ other: S) -> Zip2Sequence<Self, S> {
        Swift.zip(self, other)
    }
}

public extension Sequence {
    subscript(between range: Range<Int>) -> PrefixSequence<DropFirstSequence<Self>> {
        between(count: range.lowerBound, and: range.upperBound)
    }
}

// MARK: - Conditional Conformance

extension Sequence where Element: Sendable {
    /// Transform the sequence into an array of new values using an async closure that returns
    /// optional values. Only the non-nil values will be included in the returned array.
    ///
    /// The closure calls will be performed in order, by waiting for each call to complete before
    /// proceeding with the next one.
    ///
    /// - Parameter transform: The transform to run on each element.
    /// - Returns: The transformed values as an array. The order of the transformed sequence will
    ///            match the original sequence, except for the values transformed to `nil`.
    public func asyncCompactMap<T: Sendable>(
            _ transform: @Sendable @escaping (Element) async -> T?
    ) async -> [T] {
        var values = [T]()
        for element in self {
            guard let value = await transform(element) else {
                continue
            }
            values += value
        }
        return values
    }
    /// Transform the sequence into an array of new values using an async closure that returns
    /// optional values. Only the non-nil values will be included in the returned array.
    ///
    /// The closure calls will be performed in order, by waiting for each call to complete before
    /// proceeding with the next one. If any of the closure calls throws an error, then the iteration
    /// will be terminated and the error rethrown.
    ///
    /// - Parameter transform: The transform to run on each element.
    /// - Returns: The transformed values as an array. The order of the transformed sequence will
    ///            match the original sequence, except for the values transformed to `nil`.
    /// - Throws: Rethrows any error thrown by the passed closure.
    public func asyncCompactMap<T: Sendable>(
            _ transform: @Sendable @escaping (Element) async throws -> T?
    ) async rethrows -> [T] {
        var values = [T]()
        for element in self {
            guard let value = try await transform(element) else {
                continue
            }
            values += value
        }
        return values
    }
    public func asyncFlatMap<T: Sequence>(
            _ transform: @Sendable @escaping (Element) async -> T
    ) async -> [T.Element] where T.Element: Sendable {
        var values = [T.Element]()
        for element in self {
            await values.append(contentsOf: transform(element))
        }
        return values
    }
    public func asyncFlatMap<T: Sequence>(
            _ transform: @Sendable @escaping (Element) async throws -> T
    ) async rethrows -> [T.Element] where T.Element: Sendable {
        var values = [T.Element]()
        for element in self {
            try await values.append(contentsOf: transform(element))
        }
        return values
    }
    /// Run an async closure for each element in the sequence.
    ///
    /// The closure calls will be performed in order, by waiting for each call to complete before
    /// proceeding with the next one.
    ///
    /// - Parameter operation: The closure to run for each element.
    public func asyncForEach(
            _ operation: @Sendable @escaping (Element) async -> Void
    ) async {
        for element in self {
            await operation(element)
        }
    }
    /// Run an async closure for each element in the sequence.
    ///
    /// The closure calls will be performed in order, by waiting for each call to complete before
    /// proceeding with the next one. If any of the closure calls throws an error, then the iteration
    /// will be terminated and the error rethrown.
    ///
    /// - Parameter operation: The closure to run for each element.
    /// - Throws: Rethrows any error thrown by the passed closure.
    public func asyncForEach(
            _ operation: @Sendable @escaping (Element) async throws -> Void
    ) async rethrows {
        for element in self {
            try await operation(element)
        }
    }
    public func asyncMap<T: Sendable>(
            _ transform: @Sendable @escaping (Element) async -> T
    ) async -> [T] {
        var values = [T]()
        for element in self {
            await values += transform(element)
        }
        return values
    }
    public func asyncMap<T: Sendable>(
            _ transform: @Sendable @escaping (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()
        for element in self {
            try await values += transform(element)
        }
        return values
    }
    public func concurrentCompactMap<T: Sendable>(
            withPriority priority: TaskPriority? = nil,
            _ transform: @Sendable @escaping (Element) async -> T?
    ) async -> [T] {
        await withTaskGroup(of: (Int, T?).self) { group in
            enumerated().forEach { element in
                group.addTask(priority: priority) {
                    let value = await transform(element.1)
                    return (element.0, value)
                }
            }
            var result = [(Int, T)]()
            while let element = await group.next() {
                guard element.1.isSome else { continue }
                result += (element.0, element.1.forceUnwrap())
            }
            await group.waitForAll()
            return result.sorted { $0.0 < $1.0 }.map { $0.1 }
        }
    }
    public func concurrentCompactMap<T: Sendable>(
            withPriority priority: TaskPriority? = nil,
            _ transform: @Sendable @escaping (Element) async throws -> T?
    ) async throws -> [T] {
        try await withThrowingTaskGroup(of: (Int, T?).self) { group in
            enumerated().forEach { element in
                group.addTask(priority: priority) {
                    let value = try await transform(element.1)
                    return (element.0, value)
                }
            }
            var result = [(Int, T)]()
            while let element = try await group.next() {
                guard element.1.isSome else { continue }
                result += (element.0, element.1.forceUnwrap())
            }
            try await group.waitForAll()
            return result.sorted { $0.0 < $1.0 }.map { $0.1 }
        }
    }
    public func concurrentFlatMap<T: Sequence>(
            withPriority priority: TaskPriority? = nil,
            _ transform: @Sendable @escaping (Element) async -> T
    ) async -> [T.Element] {
        await withTaskGroup(of: (Int, T).self) { group in
            enumerated().forEach { element in
                group.addTask(priority: priority) {
                    let values = await transform(element.1)
                    return (element.0, values)
                }
            }
            var results = [(Int, T)]()
            while let value = await group.next() {
                results += value
            }
            await group.waitForAll()
            var result = [T.Element]()
            results.sorted { $0.0 < $1.0 }.forEach { result.append(contentsOf: $0.1) }
            return result
        }
    }
    public func concurrentForEach(
            withPriority priority: TaskPriority? = nil,
            _ operation: @Sendable @escaping (Element) async -> Void
    ) async {
        await withTaskGroup(of: Void.self) { group in
            for element in self {
                group.addTask(priority: priority) {
                    await operation(element)
                }
                await group.waitForAll()
            }
        }
    }
    public func concurrentForEach(
            withPriority priority: TaskPriority? = nil,
            _ operation: @Sendable @escaping (Element) async throws -> Void
    ) async rethrows {
        try await withThrowingTaskGroup(of: Void.self)  { group in
            for element in self {
                group.addTask(priority: priority) {
                    try await operation(element)
                }
            }
            try await group.waitForAll()
        }
    }
    public func concurrentMap<T: Sendable>(
            priority: TaskPriority? = nil,
            _ transform: @Sendable @escaping (Element) async -> T
    ) async -> [T] {
        await withTaskGroup(of: (Int, T).self) { group in
            enumerated().forEach { element in
                group.addTask(priority: priority) {
                    let result = await transform(element.1)
                    return (element.0, result)
                }
            }
            var result = [(Int, T)]()
            while let element = await group.next() {
                result += element
            }
            await group.waitForAll()
            return result.sorted { $0.0 < $1.0 }.map { $0.1 }
        }
    }
    public func concurrentMap<T: Sendable>(
            priority: TaskPriority? = nil,
            _ transform: @Sendable @escaping (Element) async throws -> T
    ) async rethrows -> [T] {
        try await withThrowingTaskGroup(of: (Int, T).self) { group in
            enumerated().forEach { element in
                group.addTask(priority: priority) {
                    let result = try await transform(element.1)
                    return (element.0, result)
                }
            }
            var result = [(Int, T)]()
            while let element = try await group.next() {
                result += element
            }
            try await group.waitForAll()
            return result.sorted { $0.0 < $1.0 }.map { $0.1 }   // Restore order & drop index.
        }
    }
}

extension Sequence where Element: Equatable {
    public func allElementsAreEqual(to other: Element) -> Bool {
        var iterator = makeIterator()
        while let next = iterator.next() {
            if next != other {
                return false
            }
        }
        return true
    }
    public func allElementsAreEqual() -> Bool {
        var iterator = makeIterator()
        guard let first = iterator.next() else {
            return true
        }
        while let next = iterator.next() {
            if first != next { return false }
        }
        return true
    }
    func hasPrefix(_ prefix: Element) -> Bool { first == prefix }
    func hasPrefix(_ prefix: [Element]) -> Bool {
        var iterator = makeIterator()
        var prefixIterator = prefix.makeIterator()
        while let other = prefixIterator.next() {
            if let element = iterator.next() {
                guard element == other else { return false }
            } else {
                return false
            }
        }
        return true
    }
    func hasSuffix(_ suffix: Element) -> Bool { last == suffix }
    func hasSuffix(_ suffix: [Element]) -> Bool {
        var result: Bool = false
        for (element, other) in suffix.zip(self.suffix(suffix.toAnyCollection().count)) {
            guard element == other else { return false }
            result = true
        }
        return result
    }
}

extension Sequence where Element: Comparable {
    @inlinable
    public var minimum: Element? { sorted(by: <).first }
    @inlinable
    public var maximum: Element? { sorted(by: <).last }
}

extension Sequence where Element: Numeric {
    @inlinable
    public func sum() -> Element {
        reduce(into: 0) { $0 += $1 }
    }
}

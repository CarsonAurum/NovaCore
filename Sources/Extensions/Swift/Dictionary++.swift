//
//  Created by Carson Rau on 7/5/22.
//


extension Dictionary {
    init<T: Sequence>(grouping sequence: T, by keyPath: KeyPath<T.Element, Key>) where Value == [T.Element] {
        self.init(grouping: sequence, by: { $0[keyPath: keyPath] })
    }
    public func mapKeys<T: Hashable>(_ transform: (Key) throws -> T) rethrows -> [T: Value] {
        var result: [T: Value] = .init(minimumCapacity: count)
        for (key, value) in self {
            result[try transform(key)] = value
        }
        return result
    }
    public func mapKeysAndValues<T: Hashable, U>(
        _ transformKey: (Key) throws -> T,
        _ transformValue: (Value) throws -> U
    ) rethrows -> [T: U] {
        var result: [T: U] = .init(minimumCapacity: count)
        for (key, value) in self {
            result[try transformKey(key)] = try transformValue(value)
        }
        return result
    }
    public func mapKeysAndValues<K, V>(
        _ transform: ((key: Key, value: Value)
        ) throws -> (K, V)) rethrows -> [K: V] {
        return [K: V](uniqueKeysWithValues: try map(transform))
    }
    public func reduce<T, U>(
        _ update: (inout [T: U], (key: Key, value: Value)) throws -> Void
    ) rethrows -> [T: U] {
        try reduce(into: [T:U](), update)
    }
    public func has(key: Key) -> Bool {
        index(forKey: key) != nil
    }
    public mutating func removeAll<T: Sequence>(keys: T) where T.Element == Key {
        keys.forEach { removeValue(forKey: $0) }
    }
    @discardableResult
    public mutating func removeValueForRandomKey() -> Value? {
        guard let key = keys.randomElement() else { return nil }
        return removeValue(forKey: key)
    }
    
}

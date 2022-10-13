//
// Created by Carson Rau on 1/31/22.
//

import Swift

public extension Optional {
    /// Create a new optional value wrapping the given value if the condition is true, otherwise `nil`.
    ///
    /// - Parameters:
    ///   - wrapped: The wrapped value to store in the new optional if the condition is true.
    ///   - condition: The condition to use when determining if the closure should be evaluated.
    /// - Throws: Any errors from the `wrapped` closure will be rethrown.
    @inlinable
    init(_ wrapped: @autoclosure () throws -> Wrapped, if condition: Bool) rethrows {
        self = condition ? try wrapped() : nil
    }
    /// Create a new optional value wrapping the given optional value if the condition is true, otherwise `nil`.
    ///
    /// - Parameters:
    ///   - wrapped: The optional wrapped value to store in the new optional if the condition is true.
    ///   - condition: The condition to use when determining if the closure should be evaluated.
    /// - Throws: Any errors from the `wrapped` closure will be rethrown.
    @inlinable
    init(_ wrapped: @autoclosure () throws -> Wrapped?, if condition: Bool) rethrows {
        self = condition ? try wrapped() : nil
    }
}

public extension Optional {
    /// If the wrapped value is a singly wrapped optional, unwrap one layer of the optional.
    /// - Returns: The value if it is not `nil`, `Optional.none` otherwise. No optional nesting remains.
    func compact<T>() -> T? where Wrapped == T? { self ?? .none }
    /// If the wrapped value is a doubly wrapped optional, unwrap two layers of the optional.
    /// - Returns: The value if it is not `nil`, `Optional.none` otherwise. No optional nesting remains.
    func compact<T>() -> T? where Wrapped == T?? { (self ?? .none) ?? .none }
    /// If the wrapped value is a triply wrapped optional, unwrap three layers of the optional.
    /// - Returns: The value if it is not `nil`, `Optional.none` otherwise. No optional nesting remains.
    func compact<T>() -> T? where Wrapped == T??? { ((self ?? .none) ?? .none) ?? .none }
    /// Use a given predicate closure to evaluate the wrapped value within this optional, if it exists.
    ///
    /// - Parameter predicate: The predicate function to execute when the wrapped value is not `nil`.
    /// - Returns: The wrapped value if `self` was not `nil` and the predicate evaluates to `true`. `Optional.none`
    ///   otherwise.
    /// - Throws: Any errors from the predicate will be rethrown.
    @inlinable
    func filter(_  predicate: (Wrapped) throws -> Bool) rethrows -> Wrapped? {
        try map(predicate) == .some(true) ? self : .none
    }
    /// The opposite of standard `Optional.flatMap()`, executing the closure only when the wrapped value is `nil`.
    ///
    /// - Parameter predicate: The closure to execute to provide a value when `self` is `nil`.
    /// - Returns: The value from the predicate if `self` is `nil`, or the wrapped value otherwise.
    /// - Throws: Any errors from the predicate will be rethrown.
    @inlinable
    func flatMapNil(_ predicate: () throws -> Wrapped?) rethrows -> Wrapped? {
        try self ?? predicate()
    }
    /// Forcibly unwrap this value.
    /// 
    /// - Warning: If the unwrapping fails, a runtime error will occur.
    /// - Returns: The unwrapped value.
    @inlinable
    func forceUnwrap() -> Wrapped {
        try! unwrap()
    }
    @inlinable
    var isSome: Bool { self != nil }
    @inlinable
    var isNone: Bool { self == nil }
    @inlinable
    func map(into wrapped: inout Wrapped) { map { wrapped = $0 } }
    @inlinable
    func mapNil(_ predicate: () throws -> Wrapped) rethrows -> Wrapped? {
        try self ?? .some(try predicate())
    }
    @inlinable
    func maybe<T>(_ defaultValue:  T, f: (Wrapped) throws -> T) rethrows ->  T {
        try map(f) ??  defaultValue
    }
    @inlinable
    mutating func mutate<T>(_ transform: (inout Wrapped) throws -> T) rethrows -> T? {
        guard self != nil else { return nil }
        return try transform(&self!)
    }
    @discardableResult
    @inlinable
    func onNone(_ f: () throws -> Void) rethrows -> Wrapped? {
        if isNone { try f() }
        return self
    }
    @discardableResult
    @inlinable
    func onSome(_ f: (Wrapped) throws -> Void) rethrows -> Wrapped? {
        if let wrapped = self { try f(wrapped) }
        return self
    }
    @inlinable
    func orFatallyThrow(_ message: @autoclosure () -> String) -> Wrapped {
        if let wrapped = self {
            return wrapped
        } else {
            fatalError(message())
        }
    }
    @inlinable
    mutating func remove() -> Wrapped {
        defer { self = nil }
        return self!
    }
    @inlinable
    func unwrap() throws -> Wrapped {
        guard let wrapped = self else { throw NovaError.optional }
        return wrapped
    }
    @inlinable
    func unwrapOrThrow(_ error: @autoclosure () throws -> Error) throws -> Wrapped {
        if let wrapped = self {
            return wrapped
        } else {
            throw try error()
        }
    }
}
// MARK: - Conditional Conformance
extension Optional where Wrapped: Collection {
    public var isNilOrEmpty: Bool { map { $0.isEmpty } ?? true }
}

extension Optional where Wrapped: SignedInteger {
  public var nilIfBelowZero: Wrapped? {
    let correctedValue: Wrapped?
    switch self {
    case .none:
      correctedValue = nil
    case .some(let value):
      correctedValue = value >= 0 ? value : nil
    }
    return correctedValue
  }
}

// MARK: - Operators
extension Optional {
    public static func &&-> <A>(lhs: Self, rhs: @autoclosure () throws -> A) rethrows -> A? {
        if lhs.isNone { return nil }
        return try rhs()
    }
    public static func &&-> <A>(lhs: Self, rhs: @autoclosure () throws -> A?) rethrows -> A? {
        if lhs.isNone { return nil }
        return try rhs()
    }
    public static func ||-> <A>(lhs: Self, rhs: @autoclosure () throws -> A) rethrows -> A? {
        if lhs.isSome { return nil }
        return try rhs()
    }
    public static func ||-> <A>(lhs: Self, rhs: @autoclosure () throws -> A?) rethrows -> A? {
        if lhs.isSome { return nil }
        return try rhs()
    }
}

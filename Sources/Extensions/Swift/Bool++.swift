 //
// Created by Carson Rau on 1/31/22.
//
extension Bool {
    /// Return 1 if true or 0 if false.
    @inlinable
    public var int: Int { self ? 1 : 0 }
    /// Return "true" if `true` or "false" if `false`.
    @inlinable
    public var string: String { self ? "true" : "false" }
}

extension Bool {
    /// Perform the given closure if `self` is false, otherwise `nil`.
    ///
    /// - Parameter value: The closure to evaluate if `self` is `true`. The value will be returns.
    /// - Returns: The value from the closure if `true`, `nil` otherwise.
    /// - Throws: Any errors from the closure.
    @inlinable
    public func or<A>(_ value: @autoclosure () throws -> A) rethrows -> A? {
        !self ? try value() : nil
    }
    /// Perform the given closure if `self` is false, otherwise `nil`.
    ///
    /// - Parameter value: The optional-returning closure to evaluate if `self` is `true`. The value will be returns.
    /// - Returns: The value from the closure if `true`, `nil` otherwise.
    /// - Throws: Any errors from the closure.
    @inlinable
    public func or<A>(_ value: @autoclosure () throws -> A?) rethrows -> A? {
        !self ? try value() : nil
    }
    /// Throw the given error if `self` is false.
    ///
    /// - Parameter error: The error to throw.
    /// - Throws: The given error if `self` is false.
    @inlinable
    public func orThrow(_ error: Error) throws {
        if !self {
            throw error
        }
    }
    /// Throw a predefined error if `self` is false.
    /// - Throws: ``NovaError/boolean`` if `self` is false.
    @inlinable
    public func orThrow() throws {
        try orThrow(NovaError.boolean)
    }
    /// Perform the given closure if `self` is true, otherwise `nil`.
    ///
    /// - Parameter value: The closure to evaluate if `self` is `true`. The value will be returned.
    /// - Returns: The value from the closure if `true`, `nil` otherwise.
    /// - Throws: Any errors from the closure.
    @inlinable
    public func then<A>(_ value: @autoclosure () throws -> A) rethrows -> A? {
        self ? try value() : nil
    }
    /// Perform the given optional-returning closure if `self` is true, otherwise `nil`.
    ///
    /// - Parameter value: The optional-returning closure to evaluate if `self` is `true`. The value will be
    ///   returned.
    /// - Returns: The valuye from the closure if `true`, `nil` otherwise.
    /// - Throws: Any errors from the closure.
    @inlinable
    public func then<A>(_ value: @autoclosure () throws -> A?) rethrows -> A? {
        self ? try value() : nil
    }
}

public extension Bool {
    /// Perform `rhs` only if `lhs` is true.
    ///
    /// - Parameters:
    ///    - lhs: The boolean to evaluate.
    ///    - rhs: The closure to execute if `lhs` is true.
    /// - Returns: The result of the closure if `lhs` is true, `nil` otherwise.
    @discardableResult
    @inlinable
    static func &&-> <A>(lhs: Self, rhs: @autoclosure () -> A) -> A? {
        lhs.then(rhs())
    }
    /// Perform `rhs` only if `lhs` is true.
    ///
    /// - Parameters:
    ///    - lhs: The boolean to evaluate.
    ///    - rhs: The optional-returning closure to execute if `lhs` is true.
    /// - Returns: The result of the closure if `lhs` is true, `nil` otherwise.
    @discardableResult
    @inlinable
    static func &&-> <A>(lhs: Self, rhs: @autoclosure () -> A?) -> A? {
        lhs.then(rhs())
    }
    /// Perform `rhs` only if `lhs` is false.
    ///
    /// - Parameters:
    ///   - lhs: The boolean to evaluate.
    ///   - rhs: The closure to execute if `lhs` is false.
    /// - Returns: The result of the closure if `lhs` is false, `nil` otherwise.
    @discardableResult
    @inlinable
    static func ||-> <A>(lhs: Self, rhs: @autoclosure () -> A) -> A? {
        lhs.or(rhs())
    }
    /// Perform `rhs` only if `lhs` is false.
    ///
    /// - Parameters:
    ///   - lhs: The boolean to evaluate.
    ///   - rhs: The optional-returning closure to execute if `lhs` is false.
    /// - Returns: The result of the closure if `lhs` is false, `nil` otherwise.
    @discardableResult
    @inlinable
    static func ||-> <A>(lhs: Self, rhs: @autoclosure () -> A?) -> A? {
        lhs.or(rhs())
    }
    /// Perform `rhs` only if `lhs` is true. Assign the result to `lhs`.
    ///
    /// - Parameters:
    ///   - lhs: The mutable boolean to evaluate and subsequently assign to.
    ///   - rhs: The closure to evaluate if `lhs` is true.
    @inlinable
    static func &&=(lhs: inout Self, rhs: @autoclosure () -> Self) {
        if lhs { lhs = rhs() }
    }
    /// Perform `rhs` only if `lhs` is false. Assign the result to `lhs`.
    ///
    /// - Parameters:
    ///   - lhs: The mutable boolean to evaluate and subsequently assign to.
    ///   - rhs: The closure to evaluate if `lhs` is false.
    @inlinable
    static func ||=(lhs: inout Self, rhs: @autoclosure () -> Self) {
        if !lhs {
            let rhs = rhs()
            if rhs { lhs = rhs }
        }
    }
}

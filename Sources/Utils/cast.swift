//
//  Created by Carson Rau on 2/28/22.
//

#if canImport(Foundation)
import class Foundation.NSNull
#endif

/// The core cast operation, wrapped in a function.
///
/// - Parameters:
///   - value: The value to cast.
///   - to: The type to cast to.
/// - Returns: The value after the cast, or `nil` if the cast fails.
@inlinable
public func _cast<T, U>(_ value: T, to: U.Type) -> U? {
    if let result = value as? U {
        return result
    } else {
        return nil
    }
}

/// A strong cast from one type to another.
///
/// - Parameters:
///   - value: The value to cast.
///   - type: The type to cast to.
/// - Returns: The value after the cast.
/// - Throws: An ``NovaError/invalidCast`` error if the cast fails.
@inlinable
public func cast<T, U>(_ value:  T, to type: U.Type = U.self) throws -> U {
    guard let result = value as? U else {
        throw NovaError.invalidCast
    }
    return result
}

/// A strong cast from one type to another, with a default fallback value.
///
/// - Parameters:
///   - value: The value to cast.
///   - type: The type to cast to.
///   - default: The default value to return if the cast fails.
/// - Returns: The value after the cast, or the `default` value if the cast fails.
@inlinable
public func cast<T, U>(_ value: T, to type: U.Type = U.self, `default`: U) -> U {
    guard let result = _cast(value, to: type) else { return `default` }
    return result
}

/// Optional cast from one type to another.
///
/// - Parameters:
///   - value: The value to cast.
///   - type: The type to cast to.
/// - Returns: `nil` if the provided value is `nil`, or the value after casting.
/// - Throws: An `invalidCast` error if the cast fails.
@inlinable
public func cast<T, U>(_ value: T?, to type: U.Type = U.self) throws -> U? {
    guard let value = value else { return nil }
#if canImport(Foundation)
    guard !(value is NSNull) else { return nil }
#endif
    guard let result = _cast(value, to: type) else { throw NovaError.invalidCast }
    return result
}

// MARK: - Operators

/// Strong casting operator for use in contexts with type inference.
///
/// - Note: Any errors thrown during the cast operation will cause a fatal runtime error.
///
/// - Parameter rhs: The value to cast.
/// - Returns: The value after the cast.
@inlinable
public prefix func -!> <T, U>(rhs: T) -> U {
    try! cast(rhs, to: U.self)
}
/// Strong optional casting operator for use in contexts with type inference.
///
/// - Note: Any errors thrown during the cast operation will cause a fatal runtime error.
///
/// - Parameter rhs: The value to cast.
/// - Returns: The value after the cast.
@inlinable
public prefix func -!> <T, U>(rhs: T?) -> U {
    try! cast(rhs, to: U.self)
}
/// Optional casting operator for use in contexts with type inference.
///
/// - Note: Any errors thrown during the cast operation will cause a fatal runtime error.
///
/// - Parameter rhs: The value to cast.
/// - Returns: `nil` if the given value was `NSNull`, or the value after casting.
@inlinable
public prefix func -?> <T, U>(rhs: T) -> U? {
    try? cast(rhs, to: U.self)
}
/// Optional casting operator on optional values for use in contexts with type inference.
///
/// - Note: Any errors thrown during the cast operation will cause a fatal runtime error.
///
/// - Parameter rhs: The value to cast.
/// - Returns: `nil` if the given value was `nil`, or the value after casting.
@inlinable
public prefix func -?> <T, U>(rhs: T?) -> U? {
    try? cast(rhs, to: U.self)
}
/// Type inferred unsafe bit cast.
///
/// - Parameter x: The value to cast.
/// - Returns: The value after a raw bit cast.
/// - SeeAlso: ``unsafeBitCast(_:to:)``
@inlinable
public func unsafeBitCast<T, U>(_ x: T) -> U {
    unsafeBitCast(x, to: U.self)
}
/// A bit cast operator for use in contexts with type inference.
///
/// - Parameter rhs: The value to cast.
/// - Returns: The value after a raw bit cast.
@inlinable
public prefix func -*> <T, U>(rhs: T) -> U {
    unsafeBitCast(rhs)
}

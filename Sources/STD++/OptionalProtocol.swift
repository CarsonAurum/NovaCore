//
// Created by Carson Rau on 3/27/22.
//

/// An opaque protocol wrapper for optional values (that may contain nil).
public protocol OptionalProtocol {
    /// Access to the nil instance of this type.
    static var _empty: Self { get }
    /// Create a nil instance of this type.
    init()
}

public extension OptionalProtocol {
    init() {
        self = Self._empty
    }
}

/// A semi-opaque protocol wrapper for optional values that exposes the type of the wrapped value.
public protocol AnyOptional: OptionalProtocol {
    associatedtype Wrapped
}

// MARK: - Conformance

extension Optional: AnyOptional {
    public static var _empty: Self { nil }
}

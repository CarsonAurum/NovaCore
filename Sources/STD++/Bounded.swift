//
//  Created by Carson Rau on 6/14/22.
//

public protocol Bounded: Comparable {
    static var maximum: Self { get }
    static var minimum: Self { get }
    var isMaxMin: Bool { get }
}

public extension Bounded {
    var isMaxMin: Bool { self == Self.maximum || self == Self.minimum }
}

public extension Bounded where Self: FloatingPoint {
    @inlinable
    static var maximum: Self {
        greatestFiniteMagnitude
    }
    @inlinable
    static var minimum: Self {
        -maximum
    }
}

// MARK: - Conformance

extension Int: Bounded {
    public static let minimum = min
    public static let maximum = max
}

extension Int8: Bounded {
    public static let minimum = min
    public static let maximum = max
}

extension Int16: Bounded {
    public static let minimum = min
    public static let maximum = max
}

extension Int32: Bounded {
    public static let minimum = min
    public static let maximum = max
}

extension Int64: Bounded {
    public static let minimum = min
    public static let maximum = max
}

extension UInt: Bounded {
    public static let minimum = min
    public static let maximum = max
}

extension UInt8: Bounded {
    public static let minimum = min
    public static let maximum = max
}

extension UInt16: Bounded {
    public static let minimum = min
    public static let maximum = max
}

extension UInt32: Bounded {
    public static let minimum = min
    public static let maximum = max
}

extension UInt64: Bounded {
    public static let minimum = min
    public static let maximum = max
}

extension UnicodeScalar: Bounded {
    public static var minimum = UnicodeScalar(0)!
    public static var maximum = UnicodeScalar(UInt16.maximum)!
}


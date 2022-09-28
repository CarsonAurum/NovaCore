//
//  Created by Carson Rau on 6/14/22.
//

import protocol Swift.Comparable
import struct Swift.Bool
import protocol Swift.FloatingPoint
import struct Swift.Int
import struct Swift.Int8
import struct Swift.Int16
import struct Swift.Int32
import struct Swift.Int64
import struct Swift.UInt8
import struct Swift.UInt16
import struct Swift.UInt32
import struct Swift.UInt64
import struct Swift.UnicodeScalar

/// A protocol to indicate a type has a bounded maximum and minimum value that can be compared against.
public protocol Bounded: Comparable {
    /// The maximum bound for this type.
    static var maximum: Self { get }
    /// The minimum bound for this type.
    static var minimum: Self { get }
    /// Determine if this value is equivalent to the given ``maximum`` or ``minimum`` bounds.
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


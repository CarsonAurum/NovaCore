//
// Created by Carson Rau on 3/2/22.
//

/// Bridge protocol to enable ranges in protocol programming.
///
/// Defined as structs in the standard library, range expressions do not support functions that use generic protocol conformances to support different types.
/// This hierarchy of protocols serves to bridge this gap by classifying the different range expressions into multiple child protocols to enable refined functionality.
public protocol RangeProtocol: RangeExpression {
    var lowerBound: Bound { get }
    var upperBound: Bound { get }
    func contains(_ other: Self) -> Bool
}

public protocol HalfOpenRangeProtocol: RangeProtocol { }
public protocol ClosedRangeProtocol: RangeProtocol { }
public protocol BoundedRangeProtocol: RangeProtocol {
    init(uncheckedBounds: (lower: Bound, upper: Bound))
    init(bounds: (lower: Bound, upper: Bound))
}

// MARK: - Implementation
public extension BoundedRangeProtocol {
    @inlinable
    init(uncheckedBounds bounds: (lower: Bound, upper: Bound)) {
        self.init(bounds: bounds)
    }
    init(lowerBound: Bound, upperBound: Bound) {
        self.init(bounds: (lowerBound, upperBound))
    }
}
public extension HalfOpenRangeProtocol {
    func contains(_ other: Self) -> Bool {
        (other.lowerBound >= lowerBound) && (other.lowerBound <= upperBound)
        && (other.upperBound <= upperBound) && (other.upperBound >= lowerBound)
    }
    @inlinable
    init(_ bound: Bound) where Self: BoundedRangeProtocol, Bound: Strideable {
        self.init(bounds: (lower: bound, upper: bound.successor()))
    }
    func overlaps(with other: Self) -> Bool {
        ((other.lowerBound >= lowerBound) && (other.lowerBound <= upperBound))
        || ((other.upperBound <= upperBound) && (other.upperBound >= lowerBound))
    }
}

// MARK: - Operators
public func <~= <A: HalfOpenRangeProtocol>(lhs:  A, rhs: A) -> Bool {
    guard lhs.upperBound <= rhs.upperBound else { return false }
    guard lhs.lowerBound <= rhs.lowerBound else { return false }
    return true
}
public func >~= <A: HalfOpenRangeProtocol>(lhs: A, rhs: A) -> Bool {
    guard lhs.upperBound >= rhs.upperBound else { return false }
    guard lhs.lowerBound >= rhs.lowerBound else { return false }
    return true
}
public func ..< <A: HalfOpenRangeProtocol & BoundedRangeProtocol>(lhs: A.Bound, rhs: A.Bound) -> A {
    .init(lowerBound: lhs, upperBound: rhs)
}

// MARK: - Protocol Conformances

extension ClosedRange: BoundedRangeProtocol, ClosedRangeProtocol {
    public init(bounds: (lower: Bound, upper: Bound)) {
        self = bounds.lower ... bounds.upper
    }
    public func contains(_ other: ClosedRange) -> Bool {
        other.lowerBound >= lowerBound && other.upperBound <= upperBound
    }
}

extension Range: BoundedRangeProtocol, HalfOpenRangeProtocol {
    public init(bounds: (lower: Bound, upper: Bound)) {
        self = bounds.lower ..< bounds.upper
    }
}

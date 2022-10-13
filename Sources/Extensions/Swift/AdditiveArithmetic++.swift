//
// Created by Carson Rau on 1/26/22.
//

extension AdditiveArithmetic {
    /// Returns the sum and difference of two floating point values.
    ///
    /// - Parameters:
    ///   - lhs: A first value
    ///   - rhs: A second value
    /// - Returns: A tuple containing the sum of the two values as the first element and the difference
    ///            of the two values as the second element.
    public static func ±(lhs: Self, rhs: Self) -> (Self, Self)
            where Self: FloatingPoint { (lhs + rhs, lhs - rhs) }
    /// Returns the sum and difference of two signed integer values.
    ///
    /// - Parameters:
    ///   - lhs: A first value
    ///   - rhs: A second value
    /// - Returns: A tuple containing the sum of the two values as the first element and the
    ///           difference of the two values as the second element.
    public static func ±(lhs: Self, rhs: Self) -> (Self, Self)
            where Self: SignedInteger { (lhs + rhs, lhs - rhs) }
    /// Returns the sum and difference of two unsigned integer values.
    ///
    /// - Parameters:
    ///   - rhs: A first value
    ///   - lhs: A second value
    /// - Returns: A tuple containing the sum of the two values as the first element and an optional
    ///            value as the second element containing the difference of the two values if it is
    ///            representable in the unsigned type, otherwise it is `nil`.
    public static func ±(lhs: Self, rhs: Self) -> (Self, Self?)
            where Self: UnsignedInteger {
        if lhs - rhs < 0 {
            return (lhs + rhs, nil)
        }
        return (lhs + rhs, lhs - rhs)
    }
    /// Returns the positive and negative versions of a given signed integer value as a tuple.
    ///
    /// - Parameter value: A value.
    /// - Returns: A tuple with the positive and negative variants of the given value.
    /// - Note: If the given value is positive, the tuple will have the positive value first and the
    ///         negative value second; however, if the given value is negative, the tuple will have
    ///         the negative value first and the positive value second.
    public static prefix func ±(value: Self) -> (Self, Self)
            where Self: SignedInteger { (0 as! Self) ± value }
    /// Returns the positive and negative versions of a given floating point value as a tuple.
    ///
    /// - Parameter value: A value.
    /// - Returns: A tuple with the positive and negative variants of the given value.
    /// - Note: If the given value is positive, the tuple will have the positive value first and the
    ///         negative value second; however, if the given value is negative, the tuple will have
    ///         the negative value first and the positive value second.
    public static prefix func ±(value: Self) -> (Self, Self)
            where Self: FloatingPoint { (0.0 as! Self) ± value }
    /// Returns the positive version of the given value and an empty optional indicating the absence
    /// of the negative value in the unsigned type.
    ///
    /// - Parameter value: A value.
    /// - Returns: A tuple with the positive variant of value and an optional (`nil` if not zero).
    public static prefix func ±(value: Self) -> (Self, Self?)
            where Self: UnsignedInteger {
        if value == 0 {
            return (0, 0)
        }
        return (value, nil)
    }
}

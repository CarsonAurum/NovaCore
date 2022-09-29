//
// Created by Carson Rau on 1/27/22.
//

#if canImport(Foundation)
import func Foundation.pow
#endif
import enum Swift.FloatingPointRoundingRule
import struct Swift.Int
import struct Swift.Double
import protocol Swift.BinaryFloatingPoint

extension BinaryFloatingPoint {
    #if canImport(Foundation)
        /// Returns a rounded value with the specified number of decimal places using the given rounded rule.
        ///
        /// If `numberOfDecimalPlaces` is negative, `0` will be used.
        /// - Parameters:
        ///   - numberOfDecimalPlaces: The expected number of decimal places.
        ///   - rule: The rounding rule to use.
        /// - Returns: The rounded value.
        public func rounded(to places: Int, rule: FloatingPointRoundingRule) -> Self {
            let factor = Self(pow(10.0, Double(max(0, places))))
            return (self * factor) .rounded(rule) / factor
        }
    #endif
}

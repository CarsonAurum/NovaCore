//
// Created by Carson Rau on 1/27/22.
//

extension BinaryInteger {
    /// The raw bytes of the integer.
    public var bytes: [UInt8] {
        var result = [UInt8]()
        result.reserveCapacity(MemoryLayout<Self>.size)
        var value = self
        for _ in 0 ..< MemoryLayout<Self>.size {
            result.append(UInt8(truncatingIfNeeded: value))
            value >>= 8
        }
        return result.reversed()
    }
    /// Determine if this number is even.
    public var isEven: Bool { (self % 2) == 0 }
    /// Determine if this number is odd.
    public var isOdd: Bool { (self % 2) != 0 }
    /// String formatted for values over ±1000 (example: 1k, -2k, 100k, 1kk, -5kk..).
    public var kFormatted: String {
        if self == 0 {
            return "0k"
        } else if (self >= 0 && self < 1000) || (self <= 0 && self > -1000) {
            return "0k"
        } else if (self >= 1000 && self < 1_000_000) || (self <= -1000 && self > -1_000_000) {
            return "\(self / 1000)k"
        }
        return "\(self / 100_000)kk"
    }
    /// String of format (XXh XXm) from seconds Int.
    public var timeString: String {
        guard self > 0 else { return "0 sec" }
        if self < 60 { return "\(self) sec" }
        if self < 3600 { return "\(self / 60) min" }
        let hours = self / 3600
        let mins = (self % 3600) / 60
        if hours != 0, mins == 0 { return "\(hours)h" }
        return "\(hours)h \(mins)m"
    }
}

public extension BinaryInteger {
    /// Creates a `BinaryInteger` from a raw byte representation.
    ///
    /// - Parameter bytes: An array of bytes representing the value of the integer.
    /// - Precondition: `bytes.count <= MemoryLayout<Self>.size`
    init?(bytes: [UInt8]) {
        precondition(bytes.count <= MemoryLayout<Self>.size,
                     "Integer with a \(bytes.count) byte binary representation of " +
                     "'\(bytes.map({ String($0, radix: 2) }).joined(separator: " "))' overflows " +
                     "when stored into a \(MemoryLayout<Self>.size) byte '\(Self.self)'")
        var value: Self = 0
        for byte in bytes {
            value <<= 8
            value |= Self(byte)
        }
        self.init(exactly: value)
    }
}

public extension BinaryInteger {
    /// Clamp `self` between the given numbers.
    /// - Parameters:
    ///    - lower: The lower bound.
    ///    - upper: The upper bound.
    /// - Returns: `self` if in range, `lower` if `self` is less than lower, and `upper` if `self` is greater
    ///   than `upper`.
    func clamp(lower: Self, upper: Self) -> Self {
        if self < lower {
            return lower
        } else if self > upper {
            return upper
        } else {
            return self
        }
    }
    /// Greatest common divisor of integer value and n.
    ///
    /// - Parameter number: integer value to find gcd with.
    /// - Returns: greatest common divisor of self and n.
    func gcd(of number: Self) -> Self {
        return number == 0 ?
               self : number.gcd(of: self % number)
    }
    /// Least common multiple of integer and n.
    ///
    /// - Parameter number: integer value to find lcm with.
    /// - Returns: least common multiple of self and n.
    func lcm(of number: Self) -> Self {
        return (self * number) / gcd(of: number)
    }
}

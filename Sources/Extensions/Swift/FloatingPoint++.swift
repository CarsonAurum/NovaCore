//
// Created by Carson Rau on 1/26/22.
//

public extension FloatingPoint {
    var degreesToRadian: Self {
        .pi * self / .init(180)
    }
}

extension FloatingPoint {
    public static prefix func √(value: Self) -> Self {
        return value.squareRoot()
    }
    public static func %(lhs: Self, rhs: Self) -> Self {
        lhs.truncatingRemainder(dividingBy: rhs)
    }
}

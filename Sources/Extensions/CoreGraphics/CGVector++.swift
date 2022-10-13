//
//  Created by Carson Rau on 6/27/22.
//

#if canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGVector
import func CoreGraphics.atan2
import func CoreGraphics.sqrt
import func Foundation.cos
import func Foundation.sin

extension CGVector {
    public var angle: CGFloat { atan2(dy, dx) }
    public var magnitude: CGFloat { sqrt(dx * dx + dy * dy) }
    
    public init(angle: CGFloat, magnitude: CGFloat) {
        self = .init(dx: magnitude * cos(angle), dy: magnitude * sin(angle))
    }
}

extension CGVector {
    public static func *(lhs: Self, rhs: CGFloat) -> Self {
        .init(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
    }
    public static func *(lhs: CGFloat, rhs: Self) -> Self {
        .init(dx: lhs * rhs.dx, dy: lhs * rhs.dy)
    }
    public static func *=(lhs: inout Self, rhs: CGFloat) {
        lhs.dy *= rhs
        lhs.dx *= rhs
    }
    public static prefix func -(lhs: Self) -> Self {
        .init(dx: -lhs.dx, dy: -lhs.dy)
    }
}
#endif

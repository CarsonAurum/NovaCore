//
// Created by Carson Rau on 3/8/22.
//

#if canImport(CoreGraphics)
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGPoint
import struct CoreGraphics.CGFloat

import func CoreGraphics.pow

#if canImport(SwiftUI)
import struct SwiftUI.UnitPoint
#endif

public extension CGPoint {
    #if canImport(SwiftUI)
    init(unitPoint: UnitPoint, in rect: CGRect) {
        self = .init(x: rect.width * unitPoint.x, y: rect.height - (rect.height * unitPoint.y))
    }
    #endif
}

public extension CGPoint {
    var magnitude: Double {
        let squareDouble = 2 |> flip(curry(Double.pow))
        return ((x |> squareDouble) + (y |> squareDouble)) |> Double.sqrt
    }
}

public extension CGPoint {
    func distance(from point: Self) -> CGFloat {
        CGPoint.distance(from: self, to: point)
    }
    static func distance(from p1: Self, to p2: Self) -> CGFloat {
        CGFloat.sqrt(pow(p2.x - p1.x, 2) + CGFloat.pow(p2.y - p1.y, 2))
    }
    func halfway(to point: CGPoint) -> CGPoint {
        .init(x: (x + point.x) * 0.5, y: (y + point.y) * 0.5)
    }
    static func intersection(
            start1: Self, end1: Self, start2: Self, end2: Self
    ) -> Self {
        let intersectX: CGFloat = (
          (start1.x*end1.y-start1.y*end1.x)*(start2.x-end2.x)-(start1.x-end1.x)*(start2.x*end2.y-start2.y*end2.x)
                                  ) / (
            (start1.x-end1.x)*(start2.y-end2.y)-(start1.y-end1.y)*(start2.x-end2.x)
                                    )
        let intersectY: CGFloat = (
          (start1.x*end1.y-start1.y*end1.x)*(start2.y-end2.y)-(start1.y-end1.y)*(start2.x*end2.y-start2.y*end2.x)
                                  ) / (
            (start1.x-end1.x)*(start2.y-end2.y)-(start1.y-end1.y)*(start2.x-end2.x)
                                    )
        return .init(x: intersectX, y: intersectY)
    }
    func quadCurveControlPoint(with point: Self) -> Self {
        let halfwayPoint = halfway(to: point)
        let absDist = abs(point.y - halfwayPoint.y)
        if y < point.y {
            return .init(x: halfwayPoint.x, y: halfwayPoint.y + absDist)
        } else if y > point.y {
            return .init(x: halfwayPoint.x, y: halfwayPoint.y - absDist)
        } else {
            return halfwayPoint
        }
    }
}
// MARK: - Operator
public extension CGPoint {
    static func +(lhs: Self, rhs: Self) -> Self {
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    static func +=(lhs: inout Self, rhs: Self) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
    static func -(lhs: Self, rhs: Self) -> Self {
        .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    static func -=(lhs: inout Self, rhs: Self) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
    }
    static func *(point: Self, scalar: CGFloat) -> Self {
        .init(x: point.x * scalar, y: point.y * scalar)
    }
    static func *(scalar: CGFloat, point: Self) -> Self {
        .init(x: point.x * scalar, y: point.y * scalar)
    }
    static func *=(point: inout Self, scalar: CGFloat) {
        point.x *= scalar
        point.y *= scalar
    }
}
#endif

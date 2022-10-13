//
// Created by Carson Rau on 3/18/22.
//

#if canImport(SwiftUI)
import struct SwiftUI.Path
import struct CoreGraphics.CGPoint
import struct CoreGraphics.CGVector
import struct CoreGraphics.CGFloat

import func Foundation.atan2
import func Foundation.sin
import func Foundation.cos

public extension Path {
    mutating func addCircularCornerRadiusArc(
            from start: CGPoint,
            via middle: CGPoint,
            to next: CGPoint,
            radius: CGFloat,
            clockwise: Bool
    ) {
        let lineAngle = atan2(middle.y - start.y, middle.x - start.x)
        let nextLineAngle = atan2(next.y - middle.y, next.x - middle.x)
        let lineVector = CGVector(dx: -sin(lineAngle) * radius, dy: cos(lineAngle) * radius)
        let nextLineVector = CGVector(dx: -sin(nextLineAngle) * radius, dy: cos(nextLineAngle) * radius)
        let offsetS1 = CGPoint(x: start.x + lineVector.dx, y: start.y + lineVector.dy)
        let offsetE1 = CGPoint(x: middle.x + lineVector.dx, y: middle.y + lineVector.dy)
        let offsetS2 = CGPoint(x: middle.x + nextLineVector.dx, y: middle.y + nextLineVector.dy)
        let offsetE2 = CGPoint(x: next.x + nextLineVector.dx, y: next.y + nextLineVector.dy)
        let intersect = CGPoint.intersection(
            start1: offsetS1,
            end1: offsetE1,
            start2: offsetS2,
            end2: offsetE2
        )
        let startAngle = lineAngle - (.pi / 2)
        let endAngle = nextLineAngle - (.pi / 2)
        addArc(
                center: intersect,
                radius: radius,
                startAngle: .init(radians: startAngle),
                endAngle: .init(radians: endAngle),
                clockwise: clockwise
        )
    }
    mutating func addLine(from p1: CGPoint, to p2: CGPoint) {
        move(to: p1)
        addLine(to: p2)
    }
    mutating func addQuadCurves(_ points: [CGPoint]) {
        guard points.count > 0 else { return }
        var lastPoint = points[0]
        if let currentPoint = currentPoint {
            lastPoint = currentPoint
        } else {
            move(to: lastPoint)
        }
        (1 ..< points.count).forEach {
            let nextPoint = points[$0]
            let halfway = lastPoint.halfway(to: nextPoint)
            let firstControl = halfway.quadCurveControlPoint(with: lastPoint)
            addQuadCurve(to: halfway, control: firstControl)
            let secondControl = halfway.quadCurveControlPoint(with: nextPoint)
            addQuadCurve(to: nextPoint, control: secondControl)
            lastPoint = nextPoint
        }
    }
}
#endif

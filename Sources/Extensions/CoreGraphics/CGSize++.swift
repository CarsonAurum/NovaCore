//
// Created by Carson Rau on 3/8/22.
//

#if canImport(CoreGraphics)
import struct CoreGraphics.CGSize
import struct CoreGraphics.CGFloat

public extension CGSize {
    var aspectRatio: CGFloat {
        guard height != 0 else { return 0 }
        return width / height
    }
    var maxDimension: CGFloat { max(width, height) }
    var minDimension: CGFloat { min(width, height) }
}

public extension CGSize {
    func aspectFit(to boundingSize: Self) -> Self {
        let minRatio = min(boundingSize.width / width, boundingSize.height / height)
        return .init(width: width * minRatio, height: height * minRatio)
    }
    func aspectFill(to boundingSize: Self) -> Self {
        let maxRatio = max(boundingSize.width / width, boundingSize.height / height)
        let aWidth = min(width * maxRatio, boundingSize.width)
        let aHeight = min(height * maxRatio, boundingSize.height)
        return .init(width: aWidth, height: aHeight)
    }
}
// MARK: - Operators
extension CGSize {
    public static func +(lhs: Self, rhs: Self) -> Self {
        .init(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    public static func +(lhs: Self, rhs: (width: CGFloat, height: CGFloat)) -> Self {
        .init(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    public static func +=(lhs: inout Self, rhs: Self) {
        lhs.width += rhs.width
        lhs.height += rhs.height
    }
    public static func +=(lhs: inout Self, rhs: (width: CGFloat, height: CGFloat)) {
        lhs.width += rhs.width
        lhs.height += rhs.height
    }
    public static func -(lhs: Self, rhs: Self) -> Self {
        .init(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }
    public static func -(lhs: Self, rhs: (width: CGFloat, height: CGFloat))  -> Self {
        .init(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }
    public static func -=(lhs: inout Self, rhs: Self) {
        lhs.width -= rhs.width
        lhs.height -= rhs.height
    }
    public static func -=(lhs: inout Self, rhs: (width: CGFloat, height: CGFloat)) {
        lhs.width -= rhs.width
        lhs.height -= rhs.height
    }
    public static func *(lhs: Self, rhs: Self) -> Self {
        .init(width: lhs.width * rhs.width, height: lhs.height * rhs.height)
    }
    public static func *(lhs: Self, rhs: (width: CGFloat, height: CGFloat)) -> Self {
        .init(width: lhs.width * rhs.width, height: lhs.height * rhs.height)
    }
    public static func *=(lhs: inout Self, rhs: Self) {
        lhs.width *= rhs.width
        lhs.height *= rhs.height
    }
    public static func *=(lhs: inout Self, rhs: (width: CGFloat, height: CGFloat)) {
        lhs.width *= rhs.width
        lhs.height *= rhs.height
    }
}

extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}
#endif

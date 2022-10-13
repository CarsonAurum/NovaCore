//
// Created by Carson Rau on 3/8/22.
//

#if canImport(CoreGraphics)
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGPoint
import struct CoreGraphics.CGSize

public extension CGRect {
    var center: CGPoint { .init(x: midX, y: midY) }
}

public extension CGRect {
    init(center: CGPoint, size: CGSize) {
        let origin = CGPoint(x: center.x - size.width / 2, y: center.y - size.height / 2)
        self.init(origin: origin, size: size)
    }
}

public extension CGRect {
    func resizing(to size: CGSize, anchor: CGPoint = .init(x: 0.5, y: 0.5)) -> Self {
        let sizeDelta = CGSize(width: size.width - width, height: size.height - height)
        return .init(
                origin: .init(
                        x: minX - sizeDelta.width * anchor.x,
                        y: minY - sizeDelta.height * anchor.y),
                size: size
        )
    }
}

extension CGRect: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(minX)
        hasher.combine(minY)
        hasher.combine(maxX)
        hasher.combine(maxY)
    }
}
#endif

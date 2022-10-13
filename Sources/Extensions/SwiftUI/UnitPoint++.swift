//
// Created by Carson Rau on 3/18/22.
//

#if canImport(SwiftUI)
import struct SwiftUI.UnitPoint
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGPoint

extension Collection where Element == UnitPoint {
    public func points(in rect: CGRect) -> [CGPoint] {
        map { .init(unitPoint: $0, in: rect) }
    }
}
#endif

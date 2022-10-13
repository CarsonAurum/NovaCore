//
// Created by Carson Rau on 3/8/22.
//

#if canImport(CoreGraphics) && canImport(QuartzCore)

import struct CoreGraphics.CGAffineTransform
import struct QuartzCore.CATransform3D
import func QuartzCore.CATransform3DMakeAffineTransform

public extension CGAffineTransform {
    @inlinable
    func transform3D() -> CATransform3D { CATransform3DMakeAffineTransform(self) }
}
#endif // canImport(CoreGraphics) && canImport(QuartzCore)

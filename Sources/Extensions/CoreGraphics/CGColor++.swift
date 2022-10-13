//
// Created by Carson Rau on 3/8/22.
//

#if canImport(CoreGraphics)
import class CoreGraphics.CGColor

#if canImport(UIKit)
import class UIKit.UIColor
#endif // canImport(UIKit)

#if canImport(AppKit)
import class AppKit.NSColor
#endif // canImport(AppKit)

public extension CGColor {
    #if canImport(UIKit)
    var uiColor: UIColor? {
        UIColor(cgColor: self)
    }
    #endif // canImport(UIKit)
    
    #if canImport(AppKit) && !targetEnvironment(macCatalyst)
    var nsColor: NSColor? {
        NSColor(cgColor: self)
    }
    #endif // canImport(AppKit)
}
#endif // canImport(CoreGraphics)

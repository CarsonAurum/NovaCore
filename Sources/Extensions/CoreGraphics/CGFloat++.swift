//
// Created by Carson Rau on 3/8/22.
//

#if canImport(CoreGraphics)
import CoreGraphics
import Numerics

#if canImport(Foundation)
import func Foundation.ceil
import func Foundation.floor
#endif

// MARK: - CGFloat + Numerics (Real)

extension CGFloat: Real {
    fileprivate static var is64Bit: Bool
        { MemoryLayout<Int>.size == MemoryLayout<Int64>.size }
    
    public static func exp(_ x: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.exp(.init(x))) }
        else { return .init(Float.exp(.init(x))) }
    }
    public static func expMinusOne(_ x: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.expMinusOne(.init(x))) }
        else { return .init(Float.expMinusOne(.init(x))) }
    }
    public static func cosh(_ x: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.cosh(.init(x))) }
        else { return .init(Float.cosh(.init(x))) }
    }
    public static func sinh(_ x: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.sinh(.init(x))) }
        else { return .init(Float.sinh(.init(x))) }
    }
    public static func tanh(_ x: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.tanh(.init(x))) }
        else { return .init(Float.tanh(.init(x))) }
    }
    public static func cos(_ x: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.cos(.init(x))) }
        else { return .init(Float.cos(.init(x))) }
    }
    public static func sin(_ x: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.sin(.init(x))) }
        else { return .init(Float.sin(.init(x))) }
    }
    public static func tan(_ x: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.tan(.init(x))) }
        else { return .init(Float.tan(.init(x))) }
    }
    public static func log(_ x: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.log(.init(x))) }
        else { return .init(Float.log(.init(x))) }
    }
    public static func log(onePlus x: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.log(onePlus: .init(x))) }
        else { return .init(Float.log(onePlus: .init(x))) }
    }
    public static func acosh(_ x: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.acosh(.init(x))) }
        else { return .init(Float.acosh(.init(x))) }
    }
    public static func asinh(_ x: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.asinh(.init(x))) }
        else { return .init(Float.asinh(.init(x))) }
    }
    public static func atanh(_ x: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.atanh(.init(x))) }
        else { return .init(Float.atanh(.init(x))) }
    }
    public static func acos(_ x: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.acos(.init(x))) }
        else { return .init(Float.acos(.init(x))) }
    }
    public static func asin(_ x: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.asin(.init(x))) }
        else { return .init(Float.asin(.init(x))) }
    }
    public static func atan(_ x: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.atan(.init(x))) }
        else { return .init(Float.atan(.init(x))) }
    }
    public static func pow(_ x: CGFloat, _ y: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.pow(.init(x), Double(y))) }
        else { return .init(Float.pow(.init(x), Float(y))) }
    }
    public static func pow(_ x: CGFloat, _ n: Int) -> CGFloat {
        if is64Bit { return .init(Double.pow(.init(x), n)) }
        else { return .init(Float.pow(.init(x), n)) }
    }
    public static func sqrt(_ x: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.sqrt(.init(x))) }
        else { return .init(Float.sqrt(.init(x))) }
    }
    public static func root(_ x: CGFloat, _ n: Int) -> CGFloat {
        if is64Bit { return .init(Double.root(.init(x), n)) }
        else { return .init(Float.root(.init(x), n)) }
    }
    public static func atan2(y: CGFloat, x: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.atan2(y: .init(x), x: .init(y))) }
        else { return .init(Float.atan2(y: .init(x), x: .init(y))) }
    }
    public static func erf(_ x: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.erf(.init(x))) }
        else { return .init(Float.erf(.init(x))) }
    }
    public static func erfc(_ x: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.erfc(.init(x))) }
        else { return .init(Float.erfc(.init(x))) }
    }
    public static func exp2(_ x: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.exp2(.init(x))) }
        else { return .init(Float.exp2(.init(x))) }
    }
    public static func hypot(_ x: CGFloat, _ y: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.hypot(.init(x), .init(y))) }
        else { return .init(Float.hypot(.init(x), .init(y))) }
    }
    public static func gamma(_ x: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.gamma(.init(x))) }
        else { return .init(Float.gamma(.init(x))) }
    }
    public static func log2(_ x: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.log2(.init(x))) }
        else { return .init(Float.log2(.init(x))) }
    }
    public static func log10(_ x: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.log10(.init(x))) }
        else { return .init(Float.log10(.init(x))) }
    }
    public static func logGamma(_ x: CGFloat) -> CGFloat {
        if is64Bit { return .init(Double.logGamma(.init(x))) }
        else { return .init(Float.logGamma(.init(x))) }
    }
}

// MARK: - Vars
    
public extension CGFloat {
    var abs: Self { Swift.abs(self) }
    var degreesToRadian: Self { .pi * self / 180.0 }
    var isPositive: Bool { self > 0 }
    var isNegative: Bool { self < 0 }
    var int: Int { .init(self) }
    var float: Float { .init(self) }
    var double: Double { .init(self) }
    var radiansToDegrees: Self { self * 180 / .pi }
    
    #if canImport(Foundation)
        var ceil: Self { Foundation.ceil(self) }
        var floor: Self { Foundation.floor(self) }
    #endif
}

#endif // canImport(CoreGraphics)

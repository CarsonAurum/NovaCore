//
//  Created by Carson Rau on 10/17/22.
//

import CoreGraphics

public struct Point3D: Codable, Equatable, Hashable {
    public static let zero: Self = .init(x: 0, y: 0, z: 0)
    
    public var x: Double
    public var y: Double
    public var z: Double
    
    public init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }
    public init(x: Int, y: Int, z: Int) {
        self.x = .init(x)
        self.y = .init(y)
        self.z = .init(z)
    }
    public init(x: CGFloat, y: CGFloat, z: CGFloat) {
        self.x = .init(x)
        self.y = .init(y)
        self.z = .init(z)
    }
    public init(_ x: Int, _ y: Int, _ z: Int) {
        self = .init(x: x, y: y, z: z)
    }
    public init(_ x: Double, _ y: Double, _ z: Double) {
        self = .init(x: x, y: y, z: z)
    }
    public init(_ x: CGFloat, _ y: CGFloat, _ z: CGFloat) {
        self = .init(x: x, y: y, z: z)
    }
}

// MARK: - Operators
extension Point3D {
    // +
    public static func +(lhs: Self, rhs: Double) -> Self {
        .init(lhs.x + rhs, lhs.y + rhs, lhs.z + rhs)
    }
    public static func +(lhs: Self, rhs: CGFloat) -> Self {
        lhs + Double(rhs)
    }
    public static func +(lhs: Self, rhs: Int) -> Self {
        lhs + Double(rhs)
    }
    // +=
    public static func +=(lhs: inout Self, rhs: Double) {
        lhs.x += rhs
        lhs.y += rhs
        lhs.z += rhs
    }
    public static func +=(lhs: inout Self, rhs: CGFloat) {
        lhs += Double(rhs)
    }
    public static func +=(lhs: inout Self, rhs: Int) {
        lhs += Double(rhs)
    }
    // -
    public static func -(lhs: Self, rhs: Double) -> Self {
        .init(lhs.x - rhs, lhs.y - rhs, lhs.z - rhs)
    }
    public static func -(lhs: Self, rhs: CGFloat) -> Self {
        lhs - Double(rhs)
    }
    public static func -(lhs: Self, rhs: Int) -> Self {
        lhs - Double(rhs)
    }
    // -=
    public static func -=(lhs: inout Self, rhs: Double) {
        lhs.x -= rhs
        lhs.y -= rhs
        lhs.z -= rhs
    }
    public static func -=(lhs: inout Self, rhs: CGFloat) {
        lhs -= Double(rhs)
    }
    public static func -=(lhs: inout Self, rhs: Int) {
        lhs -= Double(rhs)
    }
    // *
    public static func *(lhs: Self, rhs: Double) -> Self {
        .init(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs)
    }
    public static func *(lhs: Self, rhs: CGFloat) -> Self {
        lhs * Double(rhs)
    }
    public static func *(lhs: Self, rhs: Int) -> Self {
        lhs * Double(rhs)
    }
    // *=
    public static func *=(lhs: inout Self, rhs: Double) {
        lhs.x *= rhs
        lhs.y *= rhs
        lhs.z *= rhs
    }
    public static func *=(lhs: inout Self, rhs: CGFloat) {
        lhs *= Double(rhs)
    }
    public static func *=(lhs: inout Self, rhs: Int) {
        lhs *= Double(rhs)
    }
    // /
    public static func /(lhs: Self, rhs: Double) -> Self {
        .init(lhs.x / rhs, lhs.y / rhs, lhs.z / rhs)
    }
    public static func /(lhs: Self, rhs: CGFloat) -> Self {
        lhs / Double(rhs)
    }
    public static func /(lhs: Self, rhs: Int) -> Self {
        lhs / Double(rhs)
    }
    // /=
    public static func /=(lhs: inout Self, rhs: Double) {
        lhs.x /= rhs
        lhs.y /= rhs
        lhs.z /= rhs
    }
    public static func /=(lhs: inout Self, rhs: CGFloat) {
        lhs /= Double(rhs)
    }
    public static func /=(lhs: inout Self, rhs: Int) {
        lhs /= Double(rhs)
    }
}

// MARK: - Numeric Conformance
extension Point3D: AdditiveArithmetic {
    public static func +(lhs: Self, rhs: Self) -> Self {
        .init(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
    }
    public static func -(lhs: Self, rhs: Self) -> Self {
        .init(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
    }
}

extension Point3D: Numeric {
    public init?<T>(exactly source: T) where T : BinaryInteger {
        self.x = Double(source)
        self.y = Double(source)
        self.z = Double(source)
    }
    public var magnitude: Double {
        let squareDouble = 2 |> flip(curry(Double.pow))
        return map(squareDouble).reduce(0, +) |> Double.sqrt
    }
    public static func * (lhs: Self, rhs: Self) -> Self {
        .init(lhs.x * rhs.x, lhs.y * rhs.y, lhs.z * rhs.z)
    }
    public static func *=(lhs: inout Self, rhs: Self) {
        lhs.x *= rhs.x
        lhs.y *= rhs.y
        lhs.z *= rhs.z
    }
}

extension Point3D: SignedNumeric {
    
}

// MARK: - Sequence Conformance
internal extension Point3D {
    var arrayRep: [Double] {
        get {[x, y, z]}
        set {
            assert(newValue.count == 3)
            x = newValue[0]
            y = newValue[1]
            z = newValue[2]
        }
    }
}
extension Point3D: Sequence {
    public typealias Iterator = Array<Double>.Iterator
    public typealias Element = Double
    public func makeIterator() -> Iterator {
        arrayRep.makeIterator()
    }
}
extension Point3D: Collection {
    public typealias Index = Array<Double>.Index
    public var startIndex: Index { arrayRep.startIndex }
    public var endIndex: Index  { arrayRep.endIndex }
    public func index(after i: Index) -> Index  { arrayRep.index(after: i) }
}
extension Point3D: MutableCollection {
    public subscript(position: Index) -> Element {
        get { arrayRep[position] }
        set { arrayRep[position] = newValue }
    }
}
extension Point3D: RangeReplaceableCollection {
    public init() { self = .zero }
    public mutating func replaceSubrange<C: Collection>(
        _ subrange: Range<Array<Double>.Index>,
        with newElements: C
    ) where Double == C.Element {
            arrayRep.replaceSubrange(subrange, with: newElements)
    }
}
extension Point3D: BidirectionalCollection { }
extension Point3D: RandomAccessCollection { }

// MARK: - ExpressibleByXXXLiteral
extension Point3D: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = .zero
    }
}
extension Point3D: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int64) {
        self.x = Double(value)
        self.y = Double(value)
        self.z = Double(value)
    }
}
extension Point3D: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Double...) {
        assert(elements.count == 3)
        self.x = elements[0]
        self.y = elements[1]
        self.z = elements[2]
    }
    public init(_ elements: [Double]) {
        assert(elements.count == 3)
        self.x = elements[0]
        self.y = elements[1]
        self.z = elements[2]
    }
    public init(_ elements: [Int]) {
        assert(elements.count == 3)
        self.x = .init(elements[0])
        self.y = .init(elements[1])
        self.z = .init(elements[2])
    }
}
// MARK: - CustomDebugString
extension Point3D: CustomDebugStringConvertible {
    public var debugDescription: String {
        "<x:\(self.x) y:\(self.y) z:\(self.z)>"
    }
}

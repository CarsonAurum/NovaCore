//
// Created by Carson Rau on 2/25/22.
//

#if canImport(Dispatch)
import Dispatch
#endif
#if canImport(Foundation)
import Foundation
#endif

@dynamicMemberLookup
public struct Tagged<Tag, RawValue>: RawRepresentable, CustomStringConvertible {
    public var rawValue: RawValue
    public var description: String { String(describing: rawValue) }
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
    public func map<T>(_ f: (RawValue) -> T) ->  Tagged<Tag, T> {
        .init(rawValue: f(rawValue))
    }
    public subscript<T>(dynamicMember keyPath: KeyPath<RawValue, T>) -> T {
        rawValue[keyPath: keyPath]
    }
    public func coerced<T>(to type: T.Type) -> Tagged<T, RawValue> {
        -*>self
    }
}

// MARK: -  Conditional Conformance
extension Tagged: AdditiveArithmetic where RawValue: AdditiveArithmetic {
    public static var zero: Tagged { .init(rawValue: .zero) }
    public static func + (lhs: Tagged, rhs: Tagged) -> Tagged {
        .init(rawValue: lhs.rawValue + rhs.rawValue)
    }
    public static func += (lhs: inout Tagged, rhs: Tagged) {
        lhs.rawValue += rhs.rawValue
    }
    public static func - (lhs: Tagged, rhs: Tagged) -> Tagged {
        .init(rawValue: lhs.rawValue - rhs.rawValue)
    }
    public static func -= (lhs:  inout Tagged, rhs: Tagged) {
        lhs.rawValue -= rhs.rawValue
    }
}
extension Tagged: Collection where RawValue: Collection {
    public typealias Index = RawValue.Index
    public func index(after i: Index) -> Index {
        rawValue.index(after: i)
    }
    public subscript(position: Index) -> Element {
        rawValue[position]
    }
    public var startIndex: Index { rawValue.startIndex }
    public var endIndex: Index { rawValue.endIndex }
    public __consuming func makeIterator() -> Iterator  {
        rawValue.makeIterator()
    }
}
extension Tagged: Comparable where RawValue: Comparable {
    public static func < (lhs: Tagged, rhs: Tagged) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
extension Tagged: Decodable where RawValue: Decodable {
    public init(from decoder: Decoder) throws {
        do {
            self = .init(rawValue: try decoder.singleValueContainer().decode(RawValue.self))
        } catch {
            self = .init(rawValue: try .init(from: decoder))
        }
    }
}
extension Tagged: Encodable where RawValue: Encodable {
    public func encode(to encoder: Encoder) throws {
        do {
            var container = encoder.singleValueContainer()
            try container.encode(rawValue)
        } catch {
            try rawValue.encode(to: encoder)
        }
    }
}
extension Tagged: Equatable where  RawValue: Equatable {}
extension Tagged: Error where  RawValue: Error {}
extension Tagged: ExpressibleByArrayLiteral where RawValue: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = RawValue.ArrayLiteralElement
    public init(arrayLiteral elements: ArrayLiteralElement...) {
        let f = unsafeBitCast(
            RawValue.init(arrayLiteral:) as (ArrayLiteralElement...) -> RawValue,
            to: (([ArrayLiteralElement]) -> RawValue).self
        )
        self.init(rawValue: f(elements))
    }
}
extension Tagged: ExpressibleByBooleanLiteral where RawValue: ExpressibleByBooleanLiteral {
    public typealias BooleanLiteralType = RawValue.BooleanLiteralType
    public init(booleanLiteral value:  BooleanLiteralType)  {
        self.init(rawValue: RawValue(booleanLiteral: value))
    }
}
extension Tagged: ExpressibleByDictionaryLiteral where RawValue: ExpressibleByDictionaryLiteral {
    public typealias Key = RawValue.Key
    public typealias Value = RawValue.Value
    public init(dictionaryLiteral elements: (Key, Value)...) {
        let f = unsafeBitCast(
            RawValue.init(dictionaryLiteral:) as ((Key, Value)...) -> RawValue,
            to: (([(Key, Value)]) -> RawValue).self
        )
        self.init(rawValue: f(elements))
    }
}
extension Tagged: ExpressibleByExtendedGraphemeClusterLiteral
where RawValue: ExpressibleByExtendedGraphemeClusterLiteral {
    public typealias ExtendedGraphemeClusterLiteralType
        = RawValue.ExtendedGraphemeClusterLiteralType
    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        self.init(rawValue: RawValue(extendedGraphemeClusterLiteral: value))
    }
}
extension Tagged: ExpressibleByFloatLiteral where RawValue: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType  = RawValue.FloatLiteralType
    public init(floatLiteral value: FloatLiteralType) {
        self.init(rawValue: RawValue(floatLiteral: value))
    }
}
extension Tagged: ExpressibleByIntegerLiteral where RawValue: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = RawValue.IntegerLiteralType
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(rawValue: RawValue(integerLiteral: value))
    }
}
extension Tagged: ExpressibleByStringLiteral where RawValue: ExpressibleByStringLiteral {
    public typealias StringLiteralType = RawValue.StringLiteralType
    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: RawValue(stringLiteral: value))
    }
}
extension Tagged: ExpressibleByStringInterpolation
where RawValue: ExpressibleByStringInterpolation {
    public typealias StringInterpolation = RawValue.StringInterpolation
    public init(stringInterpolation value: StringInterpolation) {
        self.init(rawValue: RawValue(stringInterpolation: value))
    }
}
extension Tagged: ExpressibleByUnicodeScalarLiteral
where RawValue: ExpressibleByUnicodeScalarLiteral {
    public typealias UnicodeScalarLiteralType = RawValue.UnicodeScalarLiteralType
    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        self.init(rawValue: RawValue(unicodeScalarLiteral: value))
    }
}
extension Tagged: Hashable where RawValue: Hashable { }
extension Tagged: Identifiable where RawValue: Identifiable {
    public typealias ID  = RawValue.ID
    public var id: ID { rawValue.id }
}
#if canImport(Foundation)
extension Tagged: LocalizedError where RawValue: Error {
    public var errorDescription: String? { rawValue.localizedDescription }
    public var failureReason: String? { (rawValue as? LocalizedError)?.failureReason }
    public var helpAnchor: String? { (rawValue as? LocalizedError)?.helpAnchor }
    public var recoverySuggestion: String? { (rawValue as? LocalizedError)?.recoverySuggestion }
}
#endif
extension Tagged: LosslessStringConvertible where RawValue: LosslessStringConvertible {
    public init?(_ description: String) {
        guard let  rawValue = RawValue(description) else { return nil }
        self.init(rawValue: rawValue)
    }
}
extension Tagged: Numeric where RawValue: Numeric {
    public init?<C>(exactly source: C) where C: BinaryInteger {
        guard let rawValue = RawValue(exactly: source) else { return nil }
        self.init(rawValue: rawValue)
    }
    public var magnitude: RawValue.Magnitude { self.rawValue.magnitude }
    public static func * (lhs: Tagged, rhs: Tagged) -> Tagged {
        .init(rawValue: lhs.rawValue * rhs.rawValue)
    }
    public static func *= (lhs: inout Tagged, rhs: Tagged) {
        lhs.rawValue *= rhs.rawValue
    }
}
extension Tagged: Sendable where RawValue: Sendable {}
extension Tagged: Sequence where  RawValue: Sequence {
    public typealias Element = RawValue.Element
    public typealias Iterator = RawValue.Iterator
    public __consuming func makeIterator() -> Iterator {
        rawValue.makeIterator()
    }
}
extension Tagged: SignedNumeric where RawValue: SignedNumeric { }
extension Tagged: Strideable where RawValue: Strideable {
    public typealias Stride = RawValue.Stride
    public func distance(to other: Tagged<Tag, RawValue>) -> Stride {
        rawValue.distance(to: other.rawValue)
    }
    public func advanced(by n: Stride) -> Tagged<Tag, RawValue> {
        Tagged(rawValue: rawValue.advanced(by: n))
    }
}

// MARK: -  Money

public enum _Cents {}
public typealias Cents<T> = Tagged<_Cents, T>

public enum _Dollars {}
public typealias Dollars<T> = Tagged<_Dollars, T>

extension Tagged where Tag == _Cents, RawValue: BinaryFloatingPoint {
    public var dollars: Dollars<RawValue> { .init(rawValue: rawValue / 100) }
}
extension Tagged where  Tag == _Dollars, RawValue: Numeric {
    public var cents: Cents<RawValue> { .init(rawValue: rawValue * 100) }
}

// MARK: - Time

#if canImport(Dispatch) && canImport(Foundation)
public enum _Milliseconds {}
public typealias Milliseconds<T> = Tagged<_Milliseconds, T>
public enum _Seconds {}
public typealias Seconds<T> = Tagged<_Seconds, T>

extension Tagged where Tag == _Milliseconds, RawValue: BinaryFloatingPoint {
    public var seconds: Seconds<RawValue> { .init(rawValue: rawValue / 100) }
    public var timeInterval: TimeInterval {
        let seconds = self.seconds.rawValue
        return TimeInterval(
            sign: seconds.sign,
            exponentBitPattern: UInt(seconds.exponentBitPattern),
            significandBitPattern: UInt64(seconds.significandBitPattern)
        )
    }
    public var date: Date { .init(timeIntervalSince1970: timeInterval) }
}

extension Tagged where Tag == _Milliseconds, RawValue: BinaryInteger {
    public var timeInterval: TimeInterval { map(TimeInterval.init).timeInterval }
    public var dispatchTimeInterval: DispatchTimeInterval { .milliseconds(.init(rawValue)) }
    public var date: Date { .init(timeIntervalSince1970: timeInterval) }
}

extension Tagged where Tag == _Seconds, RawValue: Numeric {
    public var milliseconds: Milliseconds<RawValue> {
        .init(rawValue: rawValue * 1000)
    }
}

extension Tagged where Tag == _Seconds, RawValue: BinaryInteger {
    public var timeInterval: TimeInterval {
        .init(Int64(rawValue))
    }
    public var dispatchTimeInterval: DispatchTimeInterval {
        .seconds(Int(rawValue))
    }
    public var date: Date {
        .init(timeIntervalSince1970: timeInterval)
    }
}

public extension Date {
    func secondsSince(_ date: Date) -> Seconds<TimeInterval> {
        .init(rawValue: timeIntervalSince(date))
    }
    func millisecondsSince(_ date: Date) -> Milliseconds<TimeInterval> {
        secondsSince(date).milliseconds
    }
}
#endif

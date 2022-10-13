//
//  Created by Carson Rau on 5/4/22.
//

#if canImport(Foundation)
import class Foundation.JSONSerialization
import struct Foundation.Data

extension Data {
    public var bytes: [UInt8] { -!>self }
    public func string(encoding: String.Encoding) -> String? {
        .init(data: self, encoding: encoding)
    }
    public func jsonObject(options: JSONSerialization.ReadingOptions = []) throws -> Any {
        try JSONSerialization.jsonObject(with: self, options: options)
    }
}

extension Data {
    /// Append a new element to a collection of data.
    ///
    /// - Parameters:
    ///   - lhs: The data instance.
    ///   - rhs: A pointer to the value to append.
    /// - Returns: The data instance after appending the new record.
    public static func +=<T>(lhs: inout Self, rhs: UnsafeBufferPointer<T>) {
        lhs.append(rhs)
    }
}
#endif

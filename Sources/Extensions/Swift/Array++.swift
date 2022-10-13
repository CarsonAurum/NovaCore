//
// Created by Carson Rau on 1/26/22.
//

// MARK: - Conditional Conformances
extension Array where Element == String {
    /// Create an array of styrings from an unsafe pointer to a c-based character.
    ///
    /// - Parameters:
    ///   - pointer: The pointer whose data should be packed in the new array.
    ///   - n: The number of chars to extract from the pointer.
    public static func from(pointer: UnsafePointer<CChar>, n: Int) -> [String] {
        var ptr = pointer
        var result = [String]()
        (0 ..< n).forEach { _ in
            result += .init(cString: ptr)
            ptr = ptr.advance(to: 0).advanced(by: 1)
        }
        return result
    }
}

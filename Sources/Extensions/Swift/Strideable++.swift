//
// Created by Carson Rau on 3/2/22.
//

public extension Strideable {
    /// Mutate this strideable value by the given stride.
    ///
    /// - Parameter distance: The distance to advance this value by.
    @inlinable
    mutating func advance(by distance: Stride) {
        self = advanced(by: distance)
    }
    /// Mutate this strideable value by one.
    @inlinable
    mutating func advance() {
        advance(by: 1)
    }
    /// Access the value strided by -1.
    /// - Returns: The strided value.
    @inlinable
    func predecessor() -> Self {
        advanced(by: -1)
    }
    /// Access the value strided by +1.
    /// - Returns: The strided value.
    @inlinable
    func successor() -> Self {
        advanced(by: 1)
    }
}

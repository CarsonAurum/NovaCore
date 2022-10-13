//
//  Created by Carson Rau on 3/30/22.
//

public extension UnsafePointer {
    /// Create a new `UnsafePointer` matching the memory bounds of another pointer with a different `Pointee`.
    /// - Parameter pointer: A pointer with a different pointee whose memory bounds should be assigned to this pointer.
    init <T>(_ pointer: UnsafePointer<T>) {
        self = UnsafeRawPointer(pointer).assumingMemoryBound(to: Pointee.self)
    }
    /// Create a buffer pointer starting with `self` and continuing for the given number of elements.
    ///
    /// - Parameter n: The number of elements to allocate within the buffer pointer.
    /// - Returns: The new buffer pointer whose first element is `self`.
    func buffer(n: Int) -> UnsafeBufferPointer<Pointee> {
        .init(start: self, count: n)
    }
}

public extension UnsafePointer {
    /// Access a raw version of this pointer.
    var raw: UnsafeRawPointer {
        .init(self)
    }
    /// Access a mutable version of this pointer.
    var mutable: UnsafeMutablePointer<Pointee> {
        .init(mutating: self)
    }
}

public extension UnsafePointer where Pointee: Equatable {
    /// Advance this pointee to search for a given value. A new unsafe pointer is returned.
    ///
    /// - Warning: This function uses raw memory access and does not have any safeguards for cases in which the value is not
    ///   found within a reasonable time, or memory area. Memory access violations may occur if used incorrectly.
    /// - Parameter value: The value to search for.
    /// - Returns: A pointer to the found value.
    func advance(to value: Pointee) -> UnsafePointer {
        var ptr = self
        while ptr.pointee != value {
            ptr = ptr.advanced(by: 1)
        }
        return ptr
    }
}

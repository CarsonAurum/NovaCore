//
//  Created by Carson Rau on 5/29/22.
//

/// Unwrap a nested type from within an optional.
///
/// - Note: If the type is not an optional, no unwrapping will occur.
/// - Parameter any: An untyped optional value to unwrap.
/// - Returns: The unrwapped result -- stripped of any optionals.
public func unwrap(any: Any?) -> Any? {
    guard let any = any else { return nil }
    let mirror = Mirror(reflecting: any)
    if mirror.displayStyle != .optional { return any }
    if let (_, any) = mirror.children.first {
        return unwrap(any: any)
    }
    return nil
}

/// Flips the argument order of a zero-argument, curried function.
///
/// - Parameter f: A zero-argument, curried function.
/// - Returns: A curried function with the zero-argument surfaced.
public func flip<A, B>(_ function: @escaping (A) -> () -> B)
  -> () -> (A) -> B {
    { { function($0)() } }
}

/// Flips the argument order of a curried function.
///
/// - Parameter function: A curried function.
/// - Returns: A curried function with its first two arguments flipped.
public func flip<A, B, C>(_ function: @escaping (A) -> (B) -> C)
  -> (B) -> (A) -> C {
      { a in { function($0)(a) } }
}

/// Flips the argument order of a two-argument curried function.
///
/// - Parameter function: A two-argument, curried function.
/// - Returns: A curried function with its first two arguments flipped.
public func flip<A, B, C, D>(_ function: @escaping (A) -> (B, C) -> D)
  -> (B, C) -> (A) -> D {
      { (a, b) in { function($0)(a, b) } }
}

/// Flips the argument order of a three-argument curried function.
///
/// - Parameter function: A three-argument, curried function.
/// - Returns: A curried function with its first two arguments flipped.
public func flip<A, B, C, D, E>(_ function: @escaping (A) -> (B, C, D) -> E)
  -> (B, C, D) -> (A) -> E {
    { (a, b, c) in { function($0)(a, b, c) } }
}

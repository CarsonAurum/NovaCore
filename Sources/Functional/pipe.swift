//
// Created by Carson Rau on 3/3/22.
//

public func pipe<A, B, C>(
        _ f: @escaping (_ a: A) -> B,
        _ g: @escaping (_ b: B) -> C
) -> (A) -> C {
    { g(f($0)) }
}

public func pipe<A, B, C>(
        _ f: @escaping (_ a: A) throws -> B,
        _ g: @escaping (_ b: B) throws -> C
) -> (A) throws -> C {
    { try g(f($0)) }
}

public func pipe<A, B, C, D>(
        _ f: @escaping (_ a: A) -> B,
        _ g: @escaping (_ b: B) -> C,
        _ h: @escaping (_ c: C) -> D
) -> (A) -> D {
    { h(g(f($0))) }
}

public func pipe<A, B, C, D>(
        _ f: @escaping (_ a: A) throws -> B,
        _ g: @escaping (_ b: B) throws -> C,
        _ h: @escaping (_ c: C) throws -> D
) -> (A) throws -> D {
    { try h(g(f($0))) }
}

// MARK: - Operators
public func >>> <A, B, C>(
        _ f: @escaping (_ a: A) -> B,
        _ g: @escaping (_ b: B) -> C
) -> (A) -> C {
    pipe(f, g)
}
public func >>> <A, B, C>(
    _ f: @escaping (_ a: A) throws -> B,
    _ g: @escaping (_ b: B) throws -> C
) -> (A) throws -> C {
    pipe(f, g)
}

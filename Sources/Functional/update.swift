//
// Created by Carson Rau on 3/2/22.
//

@discardableResult
public func with <A, B>(_ a: A, _ f: @escaping (A) -> B) -> B {
    f(a)
}
public func update<A>(_ value: inout A, _ fs: (inout A) -> Void...) {
    fs.forEach { $0(&value) }
}
public func update<A>(_ value: A, _ fs: (inout A) -> Void...) -> A {
    var value = value
    fs.forEach { $0(&value) }
    return value
}
public func updateObject<A: AnyObject>(_ value: A, _ fs: (A) -> Void...) -> A {
    fs.forEach { $0(value) }
    return value
}

// MARK: - Operators


// MARK: Single
public func |> <A>(_ a: A, _ f: @escaping (inout A) -> Void) -> A {
   update(a, f)
}
public func |> <A>(_ a: inout A, _ f: @escaping (inout A) -> Void) {
    update(&a, f)
}
public func |> <A:AnyObject>(_ a: A, _ f: @escaping (A) -> Void) -> A {
    updateObject(a, f)
}
@discardableResult
public func |> <A, B>(_ a: A, _ f: @escaping (A) -> B) -> B {
    with(a, f)
}

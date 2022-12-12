//
//  File.swift
//  
//
//  Created by Carson Rau on 10/17/22.
//

public func curry <A1, A2, R> (
    _ function: @escaping (A1, A2) -> R
) -> (A1) -> (A2) -> R {
   { a in { function(a, $0) } }
}

public func curry <A1, A2, A3, R> (
    _ function: @escaping (A1, A2, A3) -> R
) -> (A1) -> (A2) -> (A3) -> R {
   { a in { b in { function(a, b, $0) } } }
}

public func curry <A1, A2, A3, A4, R> (
    _ function: @escaping (A1, A2, A3, A4) -> R
) -> (A1) -> (A2) -> (A3) -> (A4) -> R {
   { a in { b in { c in { function(a, b, c, $0) } } } }
}

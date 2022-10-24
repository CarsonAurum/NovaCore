//
//  File.swift
//  
//
//  Created by Carson Rau on 10/17/22.
//

public func curry <A1, A2, R> (
    _ function: @escaping (A1, A2) -> R
) -> (A1) -> (A2) -> R {
   { (a1: A1) -> (A2) -> R in
       { (a2: A2) -> R in
           function(a1, a2)
       }
   }
}

public func curry <A1, A2, A3, R> (
    _ function: @escaping (A1, A2, A3) -> R
) -> (A1) -> (A2) -> (A3) -> R {
   { (a1: A1) -> (A2) -> (A3) -> R in
       { (a2: A2) -> (A3) -> R in
           { (a3: A3) -> R in
               function(a1, a2, a3)
           }
       }
   }
}

public func curry <A1, A2, A3, A4, R> (
    _ function: @escaping (A1, A2, A3, A4) -> R
) -> (A1) -> (A2) -> (A3) -> (A4) -> R {
   { (a1: A1) -> (A2) -> (A3) -> (A4) -> R in
       { (a2: A2) -> (A3) -> (A4) -> R in
           { (a3: A3) -> (A4) -> R in
               { (a4: A4) -> R in
                   function(a1, a2, a3, a4)
               }
           }
       }
   }
}

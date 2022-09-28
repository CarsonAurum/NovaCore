//
// Created by Carson Rau on 3/6/22.
//

/// Assert by closure
///
/// - Parameter f: A closure to evaluate for assertion.
/// - Postcondition: Execution not continued if the asserted closure is evaluated false.
public func assert(_ f: @escaping () -> Bool) {
    assert(f())
}

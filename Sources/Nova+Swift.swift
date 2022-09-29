//
// Created by Carson Rau on 3/2/22.
//

// MARK: - Math
prefix operator ±
infix operator ±: AdditionPrecedence
prefix operator √

// MARK: Ranges
infix operator <~=: ComparisonPrecedence
infix operator >~=: ComparisonPrecedence

// MARK: Booleans
prefix operator &&
infix operator &&->: LogicalConjunctionPrecedence
infix operator ||->: LogicalDisjunctionPrecedence
infix operator &&=: AssignmentPrecedence
infix operator ||=: AssignmentPrecedence

// MARK: Casting
prefix operator -!>
prefix operator -?>
prefix operator -*>

// MARK: Functional

precedencegroup ForwardApplication {
    associativity: left
    higherThan: AssignmentPrecedence
}

precedencegroup ForwardComposition {
    associativity: left
    higherThan: ForwardApplication
}

prefix operator ^                       // KeyPath Accessor
infix operator |>: ForwardApplication   // Forward Function Application
infix operator >>>: ForwardComposition  // Forward Function Composition



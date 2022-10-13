//
//  Created by Carson Rau on 6/22/22.
//

/// A result builder to facilitate an efficient DSL syntax for array creation.
@resultBuilder
public enum ArrayBuilder {
    public static func buildBlock<Element>() -> [Element] {
        return []
    }
    public static func buildBlock<Element>(_ element: Element) -> [Element] {
        [element]
    }
    public static func buildBlock<Element>(_ elements: Element...) -> [Element] {
        elements
    }
    public static func buildBlock<Element>(_ elements: [Element]) -> [Element] {
        elements
    }
    public static func buildOptional<Element>(_ component: Element?) -> [Element] {
        if let component = component {
            return [component]
        } else {
            return []
        }
    }
    public static func buildOptional<Element>(_ component: [Element]?) -> [Element] {
        if let component = component {
            return component
        } else {
            return []
        }
    }
    public static func buildEither<Element>(first: Element) -> [Element] {
        [first]
    }
    public static func buildEither<Element>(second: Element) -> [Element] {
        [second]
    }
    public static func buildEither<Element>(first component: [Element]) -> [Element] {
        component
    }
    public static func buildEither<Element>(second component: [Element]) -> [Element] {
        component
    }
}

extension Array {
    /// Create a new array using the ``ArrayBuilder`` DSL syntax.
    /// - Parameter builder: The builder closure.
    public init(@ArrayBuilder _ builder: () -> [Element]) {
        self.init(builder())
    }
}

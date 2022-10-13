//
// Created by Carson Rau on 3/8/22.
//

public extension IteratorProtocol {
    @inlinable
    mutating func exhaust() {
        while next() != nil {
            // masturbate()
        }
    }
    @inlinable
    mutating func exhaust<A: Numeric & Strideable>(_ count: A) -> Element? where A.Stride: SignedInteger {
        var result: Element?
        (0 ..< count).forEach { _ in
            result = self.next()!
        }
        return result
    }
    @inlinable
    func exhausting() -> Self {
        update(self) { $0.exhaust() }
    }
    @inlinable
    func makeSequence() -> IteratorSequence<Self> {
        .init(self)
    }
    @inlinable
    func join<S: IteratorProtocol>(_ other: S) -> Join2Iterator<Self, S> {
        .init((self, other))
    }
}

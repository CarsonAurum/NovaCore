//
//  Created by Carson Rau on 6/3/22.
//

/// A protocol allowing the dynamic release of resources at runtime.
public protocol Disposable {
    /// A flag determining if this object should be considered disposed.
    var disposed: Bool { get }
    /// The function to handle disposal of ressources.
    func dispose()
}

public final class ActionDisposable: Disposable {
    private var action: (() -> Void)?
    public var disposed: Bool { action == nil }
    public init(action: @escaping (() -> Void)) {
        self.action = action
    }
    public func dispose() {
        self.action?()
        self.action = nil
    }
}

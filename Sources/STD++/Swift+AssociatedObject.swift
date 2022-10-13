//
//  Created by Carson Rau on 3/29/22.
//

#if canImport(ObjectiveC)
import ObjectiveC

/// A swift wrapper for the Objective-C runtime's dynamic object association capabilities.
public protocol Associable { }

// MARK: - Implementation

extension Associable where Self: AnyObject {
    /// Access the object associated with this object for a given key object.
    ///
    /// - Parameter key: The key to use when requesting the desired object.
    /// - Returns: The result, if it exists.
    public func getAssociatedObject<T>(_ key: UnsafeRawPointer) -> T? {
        (objc_getAssociatedObject(self, key) as? ObjectWrapper<T>).map { $0.value }
    }
    /// Set the object associated with this object for a given key object.
    ///
    /// - Parameters:
    ///   - key: The key to use when referencing the desired object.
    ///   - value: The value to store in association.
    public func setAssociatedObject<T>(_ key: UnsafeRawPointer, _ value: T?) {
        objc_setAssociatedObject(self, key, value.map { ObjectWrapper<T>($0) }, .OBJC_ASSOCIATION_RETAIN)
    }
    /// Set the object associated with this object for a given key object with a specified retention policy.
    ///
    /// - Parameters:
    ///   - key: The key to use when referencing the desired object.
    ///   - value: The value to store in association.
    ///   - policy: The retention policy to use.
    public func setAssociatedObject<T>(
        _ key: UnsafeRawPointer,
        _ value: T?,
        _ policy: NSObject.RetentionPolicy
    ) {
        var objcPolicy: objc_AssociationPolicy
        switch policy {
        case .assign:
            objcPolicy = .OBJC_ASSOCIATION_ASSIGN
        case .copy:
            objcPolicy = .OBJC_ASSOCIATION_COPY
        case .copyNonAtomic:
            objcPolicy = .OBJC_ASSOCIATION_COPY_NONATOMIC
        case .retain:
            objcPolicy = .OBJC_ASSOCIATION_RETAIN
        case .retainNonAtomic:
            objcPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        }
        objc_setAssociatedObject(self, key, value.map { ObjectWrapper<T>($0) }, objcPolicy)
    }
}

fileprivate class ObjectWrapper<T>: NSObject {
    public var value: T
    public init(_ value: T) {
        self.value = value
    }
}

// MARK: - Conformance

extension NSObject: Associable {
    /// A swift wrapper for the objc_AssociationPolicy enum for easy use via swift semantics.
    public enum RetentionPolicy {
        case assign
        case copy
        case copyNonAtomic
        case retain
        case retainNonAtomic
    }
}
#endif

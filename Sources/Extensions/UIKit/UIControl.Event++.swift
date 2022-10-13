//
//  Created by Carson Rau on 3/29/22.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

extension UIControl.Event: Hashable, Equatable {
    public var hashValue: Int { .init(rawValue) }
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}
#endif

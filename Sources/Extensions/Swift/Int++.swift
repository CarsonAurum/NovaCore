//
//  Created by Carson Rau on 3/30/22.
//

public extension Int {
    init<T: BinaryInteger>(integer: T) {
        switch integer {
        case let value as Int: self = value
        case let value as Int32: self = .init(value)
        case let value as Int16: self = .init(value)
        case let value as Int8: self = .init(value)
        default: self = 0
        }
    }
}

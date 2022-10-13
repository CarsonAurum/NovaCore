//
// Created by Carson Rau on 3/19/22.
//

#if canImport(Darwin)
import Darwin
#endif
#if canImport(Foundation)
import Foundation
#endif

public extension Double {
    #if !os(Linux)
    static var random: Double {
        Double(arc4random()) / Double(0xFFFFFFFF)
    }
    #endif
}
// MARK: - Time Extensions
#if canImport(Foundation)
public extension Double {
    var millisecond: TimeInterval { self / 1000 }
    var milliseconds: TimeInterval { millisecond }
    var ms: TimeInterval { millisecond }
    
    var second: TimeInterval { self }
    var seconds: TimeInterval { second }
    
    var minute: TimeInterval { self * 60 }
    var minutes: TimeInterval { minute }
    
    var hour: TimeInterval { self * 3600 }
    var hours: TimeInterval { hour }
    
    var day: TimeInterval { self * 3600 * 24 }
    var days: TimeInterval { day }
}
#endif

//
//  File.swift
//  
//
//  Created by Carson Rau on 11/17/22.
//

#if canImport(Foundation)

import Foundation

fileprivate let trueNumber = NSNumber(value: true)
fileprivate let falseNumber = NSNumber(value: false)
fileprivate let trueObjCType = String(cString: trueNumber.objCType)
fileprivate let falseObjCType = String(cString: falseNumber.objCType)

public extension NSNumber {
    var isBool: Bool {
        let objCType = String(cString: self.objCType)
        if (self.compare(trueNumber) == .orderedSame && objCType == trueObjCType)
            || (self.compare(falseNumber) == .orderedSame && objCType == falseObjCType) {
            return true
        } else {
            return false
        }
    }
    static func == (lhs: NSNumber, rhs: NSNumber) -> Bool {
        switch (lhs.isBool, rhs.isBool) {
        case (false, true): return false
        case (true, false): return false
        default:            return lhs.compare(rhs) == .orderedSame
        }
    }
    static func < (lhs: NSNumber, rhs: NSNumber) -> Bool {
        
        switch (lhs.isBool, rhs.isBool) {
        case (false, true): return false
        case (true, false): return false
        default:            return lhs.compare(rhs) == .orderedAscending
        }
    }
}

#endif

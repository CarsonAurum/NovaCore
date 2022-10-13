//
//  Created by Carson Rau on 6/27/22.
//

#if canImport(Foundation)
import struct Foundation.Date
import struct Foundation.Calendar
import func Foundation.ceil


extension Date {
    public enum DayNameStyle {
        case threeLetters
        case oneLetter
        case full
    }
    public enum MonthNameStyle {
        case threeLetters
        case oneLetter
        case full
    }
}

extension Date {
    public var calendar: Calendar { Calendar.current }
    public var era: Int { calendar.component(.era, from: self) }
    #if !os(Linux)
    public var quarter: Int {
        let month: Double = .init(calendar.component(.month, from: self))
        let nMonths: Double = .init(calendar.monthSymbols.count)
        let nMonthsInQ = nMonths / 4
        return .init(ceil(month / nMonthsInQ))
    }
    #endif // !os(Linux)
    public var weekOfYear: Int { calendar.component(.weekOfYear, from: self) }
    public var weekOfMonth: Int { calendar.component(.weekOfMonth, from: self) }
    public var weekday: Int { calendar.component(.weekday, from: self) }
    
    public var isInFuture: Bool { self > Date() }
    public var isInPast: Bool { self < Date() }
    // public var isInToday: Bool { calendar.isInToday(self) }
    public var isInYesterday: Bool { calendar.isDateInYesterday(self) }
    // public var isInTomorrow: Bool { calendar.isInTomorrow(self) }
    public var isInWeekend: Bool { calendar.isDateInWeekend(self) }
    public var isWorkday: Bool { !calendar.isDateInWeekend(self) }
    public var isInCurrentWeek: Bool { calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear) }
    public var isInCurrentMonth: Bool { calendar.isDate(self, equalTo: Date(), toGranularity: .month) }
    public var isInCurrentYear: Bool { calendar.isDate(self, equalTo: Date(), toGranularity: .year) }
    
    
    public var year: Int {
        get { calendar.component(.year, from: self) }
        set {
            guard newValue > 0 else { return }
            let curYear = calendar.component(.year, from: self)
            if let date = calendar.date(byAdding: .year, value: (newValue - curYear), to: self) {
                self = date
            }
        }
    }
    public var month: Int {
        get { calendar.component(.month, from: self) }
        set {
            let allowedRange = calendar.range(of: .month, in: .year, for: self)!
            guard allowedRange.contains(newValue) else { return }
            let curMonth = calendar.component(.month, from: self)
            if let date = calendar.date(byAdding: .month, value: (newValue - curMonth), to: self) {
                self = date
            }
        }
    }
    public var day: Int {
        get { calendar.component(.day, from: self) }
        set {
            let allowedRange = calendar.range(of: .day, in: .month, for: self)!
            guard allowedRange.contains(newValue) else { return }
            let curDay = calendar.component(.day, from: self)
            if let date = calendar.date(byAdding: .day, value: (newValue - curDay), to: self) {
                self = date
            }
        }
    }
    public var hour: Int {
        get { calendar.component(.hour, from: self) }
        set {
            let allowedRange = calendar.range(of: .hour, in: .day, for: self)!
            guard allowedRange.contains(newValue) else { return }
            let curHour = calendar.component(.hour, from: self)
            if let date = calendar.date(byAdding: .hour, value: (newValue - curHour), to: self) {
                self = date
            }
        }
    }
    public var minute: Int {
        get { calendar.component(.minute, from: self) }
        set {
            let allowedRange = calendar.range(of: .minute, in: .hour, for: self)!
            guard allowedRange.contains(newValue) else { return }
            let curMinute = calendar.component(.minute, from: self)
            if let date = calendar.date(byAdding: .minute, value: (newValue - curMinute), to: self) {
                self = date
            }
        }
    }
    public var second: Int {
        get { calendar.component(.second, from: self) }
        set {
            let allowedRange = calendar.range(of: .second, in: .minute, for: self)!
            guard allowedRange.contains(newValue) else { return }
            let curSecond = calendar.component(.second, from: self)
            if let date = calendar.date(byAdding: .second, value: (newValue - curSecond), to: self) {
                self = date
            }
        }
    }
}

#endif // canImport(Foundation)

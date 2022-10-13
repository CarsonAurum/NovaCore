//
//  Created by Carson Rau on 6/9/22.
//

#if canImport(Foundation)
import struct Foundation.Calendar
import struct Foundation.Date

extension Calendar {
    /// Count the number of days in the month of a given date.
    ///
    /// - Parameter date: The date whose month should be analyzed.
    /// - Returns: The day count for the given month.
    public func daysInMonth(for date: Date) -> Int {
        range(of: .day, in: .month, for: date)!.count
    }
}
#endif // canImport(Foundation)

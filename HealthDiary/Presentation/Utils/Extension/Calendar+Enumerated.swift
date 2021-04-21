//
//  Calendar+Enumerated.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 20/04/21.
//

import Foundation

extension Calendar {
    
    func getDays(inWeek week: Date) -> [Date] {
        guard let weekInterval = self.dateInterval(of: .weekOfMonth, for: week) else { return [] }
        return self.getDates(inside: weekInterval, matching: DateComponents(hour: 0, minute: 0, second: 0))
    }
    
    func getDays(inMonth month: Date) -> [Date] {
        var days = [Date]()
        let range = self.range(of: .day, in: .month, for: month)!
        let initialDay = self.date(from: self.dateComponents([.year, .month], from: month))!
        for counter in 0...(range.count - 1) {
            let day = self.date(byAdding: .day, value: counter, to: initialDay)!
            days.append(day)
        }
        return days
    }
    
    func getMonths(inYear interval: DateInterval) -> [Date] {
        return self.getDates(inside: interval, matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0))
    }
    
    func getWeeks(inMonth month: Date) -> [Date] {
        guard let monthInterval = self.dateInterval(of: .month, for: month) else { return [] }
        return self.getDates(inside: monthInterval,
                             matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: self.firstWeekday))
    }
    
}

extension Calendar {
    
    private func getDates(inside interval: DateInterval, matching components: DateComponents) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)
        
        self.enumerateDates(startingAfter: interval.start,
                            matching: components,
                            matchingPolicy: .nextTime) { date, _, stop in
            guard let date = date else { return }
            if date < interval.end {
                dates.append(date)
            } else {
                stop = true
            }
        }
        
        return dates
    }
    
}

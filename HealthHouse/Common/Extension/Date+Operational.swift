//
//  Date+Operational.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 22/06/21.
//

import Foundation

public extension Date {
    
    func isSameDay(with date2: Date) -> Bool {
        let formatComponents: [FormatterComponent] = [.dayOfMonthPadding,
                                                      .whitespace,
                                                      .monthOfYearDouble,
                                                      .whitespace,
                                                      .yearFullDigits]
        let date1FormattedString = self.formatted(components: formatComponents)
        let date2FormattedString = date2.formatted(components: formatComponents)
        return date1FormattedString == date2FormattedString
    }
    
    func plusDay(_ day: Int) -> Date {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = day
        return calendar.date(byAdding: dateComponents, to: self)!
    }
    
    func plusMonth(_ month: Int) -> Date {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = month
        return calendar.date(byAdding: dateComponents, to: self)!
    }
    
    func plusYear(_ year: Int) -> Date {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = year
        return calendar.date(byAdding: dateComponents, to: self)!
    }
    
}

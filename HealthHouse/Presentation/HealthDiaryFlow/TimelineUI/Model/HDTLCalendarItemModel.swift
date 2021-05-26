//
//  HDTLCalendarItemModel.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 20/04/21.
//

import Foundation
import RxDataSources

public struct HDTLCalendarItemModel {
    
    public let date: Date
    public let dateFormatted: String
    
}

extension HDTLCalendarItemModel {
    
    public static func generateDays(inYear dateInterval: DateInterval) -> [HDTLCalendarItemModel] {
        let calendar = Calendar.current
        let months = calendar.getMonths(inYear: dateInterval)
        var days = months.flatMap { calendar.getDays(inMonth: $0) }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let firstDay = dateFormatter.string(from: days[0])
        let hiddenDay = Date(timeIntervalSince1970: -1)
        var hiddenDayCount = Int(0)
        switch firstDay.lowercased() {
        case "sunday":
            hiddenDayCount = 0
        case "monday":
            hiddenDayCount = 1
        case "tuesday":
            hiddenDayCount = 2
        case "wednesday":
            hiddenDayCount = 3
        case "thursday":
            hiddenDayCount = 4
        case "friday":
            hiddenDayCount = 5
        case "saturday":
            hiddenDayCount = 6
        default:
            break
        }
        for _ in 0..<hiddenDayCount {
            days.insert(hiddenDay, at: 0)
        }
        
        let calendarItems = days.map { (day) -> HDTLCalendarItemModel in
            let dayFormatted = day.formatted(components: [.dayOfWeekWideName,
                                                          .comma,
                                                          .whitespace,
                                                          .dayOfMonth,
                                                          .whitespace,
                                                          .monthOfYearFullName,
                                                          .whitespace,
                                                          .yearFullDigits])
            return HDTLCalendarItemModel(date: day, dateFormatted: dayFormatted)
        }
        
        return calendarItems
    }
    
}

extension HDTLCalendarItemModel: Equatable {
    
    public static func == (lhs: HDTLCalendarItemModel, rhs: HDTLCalendarItemModel) -> Bool {
        return lhs.dateFormatted == rhs.dateFormatted
    }
    
}

public typealias HDTLCalendarItemModelSectionModel = AnimatableSectionModel<String, HDTLCalendarItemModel>

extension HDTLCalendarItemModel: IdentifiableType {
    
    public typealias Identity = String
    
    public var identity: String {
        return self.dateFormatted
    }
    
}

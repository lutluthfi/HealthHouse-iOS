//
//  Date+Addition.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 22/06/21.
//

import Foundation

public extension Date {
    
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

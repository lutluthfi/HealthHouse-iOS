//
//  CalendarEnumeratedTests.swift
//  HealthDiaryTests
//
//  Created by Arif Luthfiansyah on 20/04/21.
//

import XCTest
@testable import DEV_Health_Diary

class CalendarEnumeratedTests: XCTestCase {

    func test_getDaysInMonth() {
        let currMonth = Date(timeIntervalSince1970: 1614556800) // 1614556800 -> 01-03-2021 12:00:00 AM +GMT
        
        let days = Calendar.current.getDays(inMonth: currMonth)
        
        XCTAssertEqual(days.count, 31)
    }
    
    func test_getDaysInWeek() {
        let currMonth = Date(timeIntervalSince1970: 1614556800) // 1614556800 -> 01-03-2021 12:00:00 AM +GMT
        
        let days = Calendar.current.getDays(inWeek: currMonth)
        
        XCTAssertEqual(days.count, 7)
        XCTAssertEqual(Calendar.current.dateComponents([.day], from: days.first!).day, 28)
        XCTAssertEqual(Calendar.current.dateComponents([.day], from: days.last!).day, 6)
    }
    
    func test_getMonths() {
        let startDate = Date(timeIntervalSince1970: 1587254400) // 1587254400 -> 19-04-2020 12:00:00 AM +GMT
        let endDate = Date(timeIntervalSince1970: 1616112000) // 1616112000 -> 19-03-2021 12:00:00 AM +GMT
        
        let yearInterval = DateInterval(start: startDate, end: endDate)
        let months = Calendar.current.getMonths(inYear: yearInterval)
        
        XCTAssertEqual(months.count, 12)
        XCTAssertEqual(Calendar.current.dateComponents([.month], from: months.first!).month,
                       Calendar.current.dateComponents([.month], from: startDate).month)
        XCTAssertEqual(Calendar.current.dateComponents([.month], from: months.last!).month,
                       Calendar.current.dateComponents([.month], from: endDate).month)
    }
    
    func test_getWeeks() {
        let currMonth = Date(timeIntervalSince1970: 1614556800) // 1614556800 -> 01-03-2021 12:00:00 AM +GMT
        
        let weeks = Calendar.current.getWeeks(inMonth: currMonth)
        
        XCTAssertEqual(weeks.count, 5)
    }

}

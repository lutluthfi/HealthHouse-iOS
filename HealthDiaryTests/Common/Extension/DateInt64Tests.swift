//
//  Date+Int64.swift
//  HealthDiaryTests
//
//  Created by Arif Luthfiansyah on 31/03/21.
//

import XCTest

class DateInt64Tests: XCTestCase {
    
    private let timestamp = Int64(978282061)
    private let timestampMillisecond = Int64(978282061000)
    private let date: Date = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.date(from: "01-01-2001 01:01:01 AM")!
    }()
    
    func test_toInt64_whenNotInMillis_shouldEqual() {
        XCTAssertEqual(self.date.toInt64(), self.timestamp)
    }
    
    func test_toInt64_whenInMillis_shouldEqual() {
        XCTAssertEqual(self.date.toInt64(inMillis: true), self.timestampMillisecond)
    }
    
}

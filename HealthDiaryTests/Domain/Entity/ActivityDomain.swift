//
//  ActivityDomain.swift
//  HealthDiaryTests
//
//  Created by Arif Luthfiansyah on 21/03/21.
//

import XCTest
@testable import DEV_Health_Diary

extension ActivityDomain {
    
    static var stubCollection: [ActivityDomain] {
        let now = Date()
        return [
            ActivityDomain(createdAt: now.toInt64(),
                           updatedAt: now.toInt64(),
                           icon: "icon",
                           notes: "notes",
                           title: "title 1"),
            ActivityDomain(createdAt: now.toInt64(),
                           updatedAt: now.toInt64(),
                           icon: "icon",
                           notes: "notes",
                           title: "title 2"),
            ActivityDomain(createdAt: now.toInt64(),
                           updatedAt: now.toInt64(),
                           icon: "icon",
                           notes: "notes",
                           title: "title 3"),
            ActivityDomain(createdAt: now.toInt64(),
                           updatedAt: now.toInt64(),
                           icon: "icon",
                           notes: "notes",
                           title: "title 4"),
            ActivityDomain(createdAt: now.toInt64(),
                           updatedAt: now.toInt64(),
                           icon: "icon",
                           notes: "notes",
                           title: "title 5")
        ]
    }
    
    static var stubElement: ActivityDomain {
        let now = Date()
        return ActivityDomain(createdAt: now.toInt64(),
                              updatedAt: now.toInt64(),
                              icon: "icon",
                              notes: "notes",
                              title: "title")
    }
    
}

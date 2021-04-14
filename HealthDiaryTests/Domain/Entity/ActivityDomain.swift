//
//  ActivityDomain.swift
//  HealthDiaryTests
//
//  Created by Arif Luthfiansyah on 21/03/21.
//

import XCTest
@testable import DEV_Health_Diary

extension ActivityDomain {
    
    static func stubCollection(coreDataStorage: CoreDataStorageSharedMock) -> [ActivityDomain] {
        let insertedProfileEntity = ProfileEntity(.stubElement, insertInto: coreDataStorage.context)
        coreDataStorage.saveContext()
        let insertedProfileDomain = insertedProfileEntity.toDomain()
        let now = Date()
        return [ActivityDomain(coreID: nil,
                               createdAt: now.toInt64(),
                               updatedAt: now.toInt64(),
                               doDate: now.toInt64(),
                               explanation: "Activity Stub Collection 1",
                               isArchived: false,
                               isPinned: false,
                               photoFileNames: [],
                               title: "Activity Stub Collection 1",
                               profile: insertedProfileDomain),
                ActivityDomain(coreID: nil,
                               createdAt: now.toInt64(),
                               updatedAt: now.toInt64(),
                               doDate: now.toInt64(),
                               explanation: "Activity Stub Collection 2",
                               isArchived: false,
                               isPinned: false,
                               photoFileNames: [],
                               title: "Activity Stub Collection 2",
                               profile: insertedProfileDomain),
                ActivityDomain(coreID: nil,
                               createdAt: now.toInt64(),
                               updatedAt: now.toInt64(),
                               doDate: now.toInt64(),
                               explanation: "Activity Stub Collection 3",
                               isArchived: false,
                               isPinned: false,
                               photoFileNames: [],
                               title: "Activity Stub Collection 3",
                               profile: insertedProfileDomain),
                ActivityDomain(coreID: nil,
                               createdAt: now.toInt64(),
                               updatedAt: now.toInt64(),
                               doDate: now.toInt64(),
                               explanation: "Activity Stub Collection 4",
                               isArchived: false,
                               isPinned: false,
                               photoFileNames: [],
                               title: "Activity Stub Collection 4",
                               profile: insertedProfileDomain),
                ActivityDomain(coreID: nil,
                               createdAt: now.toInt64(),
                               updatedAt: now.toInt64(),
                               doDate: now.toInt64(),
                               explanation: "Activity Stub Collection 5",
                               isArchived: false,
                               isPinned: false,
                               photoFileNames: [],
                               title: "Activity Stub Collection 5",
                               profile: insertedProfileDomain)]
    }
    
    static func stubRemoveElement(coreDataStorage: CoreDataStorageSharedMock) -> ActivityDomain {
        let insertedProfileEntity = ProfileEntity(.stubElement, insertInto: coreDataStorage.context)
        coreDataStorage.saveContext()
        let insertedProfileDomain = insertedProfileEntity.toDomain()
        let now = Date()
        return ActivityDomain(coreID: nil,
                              createdAt: now.toInt64(),
                              updatedAt: now.toInt64(),
                              doDate: now.toInt64(),
                              explanation: "Activity Stub Remove Element",
                              isArchived: false,
                              isPinned: false,
                              photoFileNames: [],
                              title: "Activity Stub Remove Element",
                              profile: insertedProfileDomain)
    }
    
    static func stubElement(coreDataStorage: CoreDataStorageSharedMock) -> ActivityDomain {
        let insertedProfileEntity = ProfileEntity(.stubElement, insertInto: coreDataStorage.context)
        coreDataStorage.saveContext()
        let insertedProfileDomain = insertedProfileEntity.toDomain()
        let now = Date()
        return ActivityDomain(coreID: nil,
                              createdAt: now.toInt64(),
                              updatedAt: now.toInt64(),
                              doDate: now.toInt64(),
                              explanation: "Activity Stub Element",
                              isArchived: false,
                              isPinned: false,
                              photoFileNames: [],
                              title: "Activity Stub Element",
                              profile: insertedProfileDomain)
    }
    
}

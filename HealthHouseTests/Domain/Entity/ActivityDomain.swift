//
//  ActivityDomain.swift
//  HealthDiaryTests
//
//  Created by Arif Luthfiansyah on 21/03/21.
//

import XCTest
@testable import DEV_Health_Diary

// MARK: StubCollection
extension ActivityDomain {
    
    @discardableResult
    static func stubCollectionCoreData(coreDataStorage: CoreDataStorageSharedMock) -> ([ActivityDomain], ProfileDomain) {
        let profile = ProfileDomain.stubElementCoreData(coreDataStorage: coreDataStorage)
        let now = Date()
        let activities = [ActivityDomain(coreID: nil,
                                         createdAt: now.toInt64(),
                                         updatedAt: now.toInt64(),
                                         doDate: now.toInt64(),
                                         explanation: "Activity Stub Collection 1",
                                         isArchived: false,
                                         isPinned: false,
                                         photoFileNames: [],
                                         title: "Activity Stub Collection 1",
                                         label: nil,
                                         profile: profile),
                          ActivityDomain(coreID: nil,
                                         createdAt: now.toInt64(),
                                         updatedAt: now.toInt64(),
                                         doDate: now.toInt64(),
                                         explanation: "Activity Stub Collection 2",
                                         isArchived: false,
                                         isPinned: false,
                                         photoFileNames: [],
                                         title: "Activity Stub Collection 2",
                                         label: nil,
                                         profile: profile),
                          ActivityDomain(coreID: nil,
                                         createdAt: now.toInt64(),
                                         updatedAt: now.toInt64(),
                                         doDate: now.toInt64(),
                                         explanation: "Activity Stub Collection 3",
                                         isArchived: false,
                                         isPinned: false,
                                         photoFileNames: [],
                                         title: "Activity Stub Collection 3",
                                         label: nil,
                                         profile: profile),
                          ActivityDomain(coreID: nil,
                                         createdAt: now.toInt64(),
                                         updatedAt: now.toInt64(),
                                         doDate: now.toInt64(),
                                         explanation: "Activity Stub Collection 4",
                                         isArchived: false,
                                         isPinned: false,
                                         photoFileNames: [],
                                         title: "Activity Stub Collection 4",
                                         label: nil,
                                         profile: profile),
                          ActivityDomain(coreID: nil,
                                         createdAt: now.toInt64(),
                                         updatedAt: now.toInt64(),
                                         doDate: now.toInt64(),
                                         explanation: "Activity Stub Collection 5",
                                         isArchived: false,
                                         isPinned: false,
                                         photoFileNames: [],
                                         title: "Activity Stub Collection 5",
                                         label: nil,
                                         profile: profile)]
        let activityEntities = activities.map { ActivityEntity($0, insertInto: coreDataStorage.context) }
        coreDataStorage.saveContext()
        let _activities = activityEntities
            .map { $0.toDomain(context: coreDataStorage.context) }
            .sorted(by: { $0.title < $1.title })
        return (_activities, profile)
    }
    
}

// MARK: StubElement
extension ActivityDomain {
    
    @discardableResult
    static func stubElement(coreDataStorage: CoreDataStorageSharedMock) -> (ActivityDomain, ProfileDomain) {
        let profile = ProfileDomain.stubElementCoreData(coreDataStorage: coreDataStorage)
        let now = Date()
        let activity = ActivityDomain(coreID: nil,
                                      createdAt: now.toInt64(),
                                      updatedAt: now.toInt64(),
                                      doDate: now.toInt64(),
                                      explanation: "Activity Stub Element",
                                      isArchived: false,
                                      isPinned: false,
                                      photoFileNames: [],
                                      title: "Activity Stub Element",
                                      label: nil,
                                      profile: profile)
        return (activity, profile)
    }
    
    @discardableResult
    static func stubElementCoreData(coreDataStorage: CoreDataStorageSharedMock) -> (ActivityDomain, ProfileDomain) {
        let context = coreDataStorage.context
        let profile = ProfileDomain.stubElementCoreData(coreDataStorage: coreDataStorage)
        let now = Date()
        let activity = ActivityDomain(coreID: nil,
                                      createdAt: now.toInt64(),
                                      updatedAt: now.toInt64(),
                                      doDate: now.toInt64(),
                                      explanation: "Activity Stub Element",
                                      isArchived: false,
                                      isPinned: false,
                                      photoFileNames: [],
                                      title: "Activity Stub Element",
                                      label: nil,
                                      profile: profile)
        let activityEntity = ActivityEntity(activity, insertInto: context)
        coreDataStorage.saveContext()
        let _activity = activityEntity.toDomain(context: context)
        return (_activity, profile)
    }
    
}

// MARK: StubRemoveElement
extension ActivityDomain {
    
    @discardableResult
    static func stubRemoveElementCoreData(coreDataStorage: CoreDataStorageSharedMock) -> (ActivityDomain, ProfileDomain) {
        let context = coreDataStorage.context
        let profile = ProfileDomain.stubElementCoreData(coreDataStorage: coreDataStorage)
        let now = Date()
        let activity = ActivityDomain(coreID: nil,
                                      createdAt: now.toInt64(),
                                      updatedAt: now.toInt64(),
                                      doDate: now.toInt64(),
                                      explanation: "Activity Stub Remove Element",
                                      isArchived: false,
                                      isPinned: false,
                                      photoFileNames: [],
                                      title: "Activity Stub Remove Element",
                                      label: nil,
                                      profile: profile)
        let activityEntity = ActivityEntity(activity, insertInto: context)
        coreDataStorage.saveContext()
        context.delete(activityEntity)
        coreDataStorage.saveContext()
        return (activity, profile)
    }
    
}

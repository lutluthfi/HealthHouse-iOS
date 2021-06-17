//
//  ActivityFlag.swift
//  HealthHouseTests
//
//  Created by Arif Luthfiansyah on 16/05/21.
//

import Foundation
@testable import Health_House

// MARK: StubCollection
extension ActivityFlagDomain {
    
    @discardableResult
    static func stubCollection(coreDataStorage: CoreDataStorageSharedMock) -> [ActivityFlagDomain] {
        let now = Date()
        let activities = ActivityDomain.stubCollectionCoreData(coreDataStorage: coreDataStorage)
        let flags = Flag.stubCollectionCoreData(coreDataStorage: coreDataStorage)
        let activityFlags = activities.0.map({
            ActivityFlagDomain(coreID: nil,
                               createdAt: now.toInt64(),
                               updatedAt: now.toInt64(),
                               activity: $0,
                               flags: flags)
        })
        return activityFlags
    }
    
    @discardableResult
    static func stubCollectionCoreData(coreDataStorage: CoreDataStorageSharedMock) -> ([ActivityFlagDomain],
                                                                                       ProfileDomain) {
        let now = Date()
        let activities = ActivityDomain.stubCollectionCoreData(coreDataStorage: coreDataStorage)
        let flags = Flag.stubCollectionCoreData(coreDataStorage: coreDataStorage)
        let activityFlags = activities.0.map({
            ActivityFlagDomain(coreID: nil,
                               createdAt: now.toInt64(),
                               updatedAt: now.toInt64(),
                               activity: $0,
                               flags: flags)
        })
        let entities = activityFlags.map({ ActivityFlagEntity($0, insertInto: coreDataStorage.context) })
        coreDataStorage.saveContext()
        let _activitiyFlags = entities
            .map({ $0.toDomain(context: coreDataStorage.context) })
            .sorted(by: { $0.activity.createdAt < $1.activity.createdAt })
        return (_activitiyFlags, activities.1)
    }
    
}

// MARK: StubElement
extension ActivityFlagDomain {
    
    @discardableResult
    static func stubElementWhenActivityHasCoreID(coreDataStorage: CoreDataStorageSharedMock) -> ActivityFlagDomain {
        let now = Date()
        let activity = ActivityDomain.stubElementCoreData(coreDataStorage: coreDataStorage).0
        let flags = Flag.stubCollectionCoreData(coreDataStorage: coreDataStorage)
        let activityFlag = ActivityFlagDomain(coreID: nil,
                                              createdAt: now.toInt64(),
                                              updatedAt: now.toInt64(),
                                              activity: activity,
                                              flags: flags)
        return activityFlag
    }
    
    @discardableResult
    static func stubElementWhenActivityHasNotCoreID(coreDataStorage: CoreDataStorageSharedMock) -> ActivityFlagDomain {
        let now = Date()
        let activity = ActivityDomain.stubElement(coreDataStorage: coreDataStorage).0
        let flags = Flag.stubCollectionCoreData(coreDataStorage: coreDataStorage)
        let activityFlag = ActivityFlagDomain(coreID: nil,
                                              createdAt: now.toInt64(),
                                              updatedAt: now.toInt64(),
                                              activity: activity,
                                              flags: flags)
        return activityFlag
    }
    
    @discardableResult
    static func stubElementCoreData(coreDataStorage: CoreDataStorageSharedMock) -> ActivityFlagDomain {
        let now = Date()
        let activity = ActivityDomain.stubElementCoreData(coreDataStorage: coreDataStorage).0
        let flags = Flag.stubCollectionCoreData(coreDataStorage: coreDataStorage)
        let activityFlag = ActivityFlagDomain(coreID: nil,
                                              createdAt: now.toInt64(),
                                              updatedAt: now.toInt64(),
                                              activity: activity,
                                              flags: flags)
        let entity = ActivityFlagEntity(activityFlag, insertInto: coreDataStorage.context)
        coreDataStorage.saveContext()
        let _activityFlag = entity.toDomain(context: coreDataStorage.context)
        return _activityFlag
    }
    
}

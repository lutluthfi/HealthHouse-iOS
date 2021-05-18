//
//  XCTest+SUT.swift
//  HealthHouseTests
//
//  Created by Arif Luthfiansyah on 21/03/21.
//

import CoreData
import RxSwift
import RxTest
import XCTest
@testable import Health_House

public extension XCTest {
    
    func makeDisposeBag() -> DisposeBag {
        return DisposeBag()
    }
    
    func makeSempahore() -> DispatchSemaphore {
        return DispatchSemaphore(value: 0)
    }
    
    func makeCoreDataStorageMock() -> CoreDataStorageSharedMock {
        return CoreDataStorageMock()
    }
    
    func makeUserDefaults() -> UserDefaults {
        return UserDefaults(suiteName: #file)!
    }
    
    func clearCoreDataStorage() {
        let coreDataStorage = self.makeCoreDataStorageMock()
        let context = coreDataStorage.context
        
        let profileRequest: NSFetchRequest =  ProfileEntity.fetchRequest()
        let profiles = try! context.fetch(profileRequest)
        profiles.forEach { context.delete($0) }
        
        let activityRequest: NSFetchRequest = ActivityEntity.fetchRequest()
        let activityEntities = try! context.fetch(activityRequest)
        activityEntities.forEach { context.delete($0) }
        
        let flagRequest: NSFetchRequest = FlagEntity.fetchRequest()
        let flagEntities = try! context.fetch(flagRequest)
        flagEntities.forEach { context.delete($0) }
        
        let activityFlagRequest: NSFetchRequest = ActivityFlagEntity.fetchRequest()
        let activityFlagEntities = try! context.fetch(activityFlagRequest)
        activityFlagEntities.forEach { context.delete($0) }
        
        coreDataStorage.saveContext()
    }
    
    func removeUserDefaults() {
        let userDefaults = self.makeUserDefaults()
        userDefaults.removePersistentDomain(forName: #file)
    }
    
}

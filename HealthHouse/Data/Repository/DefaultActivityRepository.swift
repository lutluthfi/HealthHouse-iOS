//
//  DefaultActivityRepository.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 27/03/21.
//

import Foundation
import RxSwift

class DefaultActivityRepository {
    
    let localActivityStorage: LocalActivityStorage
    
    init(localActivityStorage: LocalActivityStorage) {
        self.localActivityStorage = localActivityStorage
    }
    
}

extension DefaultActivityRepository: ActivityRepository {
    
    func fetchAllActivity(in storagePoint: StoragePoint) -> Single<[Activity]> {
        switch storagePoint {
        case .realm:
            return self.localActivityStorage.fetchAllInCoreData()
        case .remote:
            return StoragePoint.makeRemoteStorageNotSupported(class: ActivityRepository.self,
                                                              function: "fetchAllActivity()",
                                                              object: [Activity].self)
        case .userDefaults:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: ActivityRepository.self,
                                                                   function: "fetchAllActivity()",
                                                                   object: [Activity].self)
        }
    }
    
    func fetchAllActivity(ownedBy profile: Profile,
                          in storagePoint: StoragePoint) -> Single<[Activity]> {
        switch storagePoint {
        case .realm:
            return self.localActivityStorage.fetchAllInCoreData(ownedBy: profile)
        case .remote:
            return StoragePoint.makeRemoteStorageNotSupported(class: ActivityRepository.self,
                                                              function: "fetchAllActivity(ownedBy:)",
                                                              object: [Activity].self)
        case .userDefaults:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: ActivityRepository.self,
                                                                   function: "fetchAllActivity(ownedBy:)",
                                                                   object: [Activity].self)
        }
    }
    
    func fetchAllActivity(ownedBy profile: Profile,
                          onDoDate doDate: Date,
                          in storagePoint: StoragePoint) -> Single<[Activity]> {
        switch storagePoint {
        case .realm:
            return self.localActivityStorage.fetchAllInCoreData(ownedBy: profile, onDoDate: doDate)
        case .remote:
            return StoragePoint.makeRemoteStorageNotSupported(class: ActivityRepository.self,
                                                              function: "fetchAllActivity(ownedBy:, onDoDate:)",
                                                              object: [Activity].self)
        case .userDefaults:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: ActivityRepository.self,
                                                                   function: "fetchAllActivity(ownedBy:, onDoDate:)",
                                                                   object: [Activity].self)
        }
    }
    
    func insertUpdateActivity(_ activity: Activity,
                              into storagePoint: StoragePoint) -> Single<Activity> {
        switch storagePoint {
        case .realm:
            return self.localActivityStorage.insertIntoCoreData(activity)
        case .remote:
            return StoragePoint.makeRemoteStorageNotSupported(class: ActivityRepository.self,
                                                              function: "insertUpdateActivity()",
                                                              object: Activity.self)
        case .userDefaults:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: ActivityRepository.self,
                                                                   function: "insertUpdateActivity()",
                                                                   object: Activity.self)
        }
    }
    
}

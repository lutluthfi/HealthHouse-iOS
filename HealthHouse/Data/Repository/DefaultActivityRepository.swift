//
//  DefaultActivityRepository.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 27/03/21.
//

import Foundation
import RxSwift

public class DefaultActivityRepository {
    
    let localActivityStorage: LocalActivityStorage
    
    public init(localActivityStorage: LocalActivityStorage) {
        self.localActivityStorage = localActivityStorage
    }
    
}

extension DefaultActivityRepository: ActivityRepository {
    
    public func fetchAllActivity(in storagePoint: StoragePoint) -> Observable<[ActivityDomain]> {
        switch storagePoint {
        case .coreData:
            return self.localActivityStorage.fetchAllInCoreData()
        case .remote:
            return StoragePoint.makeRemoteStorageNotSupported(class: ActivityRepository.self,
                                                              function: "fetchAllActivity()",
                                                              object: [ActivityDomain].self)
        case .userDefaults:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: ActivityRepository.self,
                                                                   function: "fetchAllActivity()",
                                                                   object: [ActivityDomain].self)
        }
    }
    
    public func fetchAllActivity(ownedBy profile: ProfileDomain,
                                 in storagePoint: StoragePoint) -> Observable<[ActivityDomain]> {
        switch storagePoint {
        case .coreData:
            return self.localActivityStorage.fetchAllInCoreData(ownedBy: profile)
        case .remote:
            return StoragePoint.makeRemoteStorageNotSupported(class: ActivityRepository.self,
                                                              function: "fetchAllActivity(ownedBy:)",
                                                              object: [ActivityDomain].self)
        case .userDefaults:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: ActivityRepository.self,
                                                                   function: "fetchAllActivity(ownedBy:)",
                                                                   object: [ActivityDomain].self)
        }
    }
    
    public func fetchAllActivity(ownedBy profile: ProfileDomain,
                                 onDoDate doDate: Int64,
                                 in storagePoint: StoragePoint) -> Observable<[ActivityDomain]> {
        switch storagePoint {
        case .coreData:
            return self.localActivityStorage.fetchAllInCoreData(ownedBy: profile, onDoDate: doDate)
        case .remote:
            return StoragePoint.makeRemoteStorageNotSupported(class: ActivityRepository.self,
                                                              function: "fetchAllActivity(ownedBy:, onDoDate:)",
                                                              object: [ActivityDomain].self)
        case .userDefaults:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: ActivityRepository.self,
                                                                   function: "fetchAllActivity(ownedBy:, onDoDate:)",
                                                                   object: [ActivityDomain].self)
        }
    }
    
    public func insertUpdateActivity(_ activity: ActivityDomain,
                               into storagePoint: StoragePoint) -> Observable<ActivityDomain> {
        switch storagePoint {
        case .coreData:
            return self.localActivityStorage.insertIntoCoreData(activity)
        case .remote:
            return StoragePoint.makeRemoteStorageNotSupported(class: ActivityRepository.self,
                                                              function: "insertUpdateActivity()",
                                                              object: ActivityDomain.self)
        case .userDefaults:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: ActivityRepository.self,
                                                                   function: "insertUpdateActivity()",
                                                                   object: ActivityDomain.self)
        }
    }
    
}

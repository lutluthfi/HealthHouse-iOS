//
//  DefaultActivityRepository.swift
//  HealthDiary
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
        case .userDefault:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: ActivityRepository.self,
                                                                   function: "fetchAllActivity()",
                                                                   object: [ActivityDomain].self)
        }
    }
    
    public func insertActivity(_ activity: ActivityDomain,
                               into storagePoint: StoragePoint) -> Observable<ActivityDomain> {
        switch storagePoint {
        case .coreData:
            return self.localActivityStorage.insertIntoCoreData(activity)
        case .remote:
            return StoragePoint.makeRemoteStorageNotSupported(class: ActivityRepository.self,
                                                              function: "insertActivity()",
                                                              object: ActivityDomain.self)
        case .userDefault:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: ActivityRepository.self,
                                                                   function: "insertActivity()",
                                                                   object: ActivityDomain.self)
        }
    }
    
}

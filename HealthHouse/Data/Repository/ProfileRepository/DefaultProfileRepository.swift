//
//  DefaultProfileRepository.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 15/04/21.
//

import Foundation
import RxSwift

public class DefaultProfileRepository {
    
    let localProfileStorage: LocalProfileStorage
    
    public init(localProfileStorage: LocalProfileStorage) {
        self.localProfileStorage = localProfileStorage
    }
    
}

extension DefaultProfileRepository: ProfileRepository {
    
    public func fetchAllProfile(in storagePoint: StoragePoint) -> Observable<[ProfileDomain]> {
        switch storagePoint  {
        case .coreData:
            return self.localProfileStorage.fetchAllInCoreData()
        case .remote:
            return StoragePoint.makeRemoteStorageNotSupported(class: ProfileRepository.self,
                                                              function: "fetchAllProfile()",
                                                              object: [ProfileDomain].self)
        case .userDefaults:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: ProfileRepository.self,
                                                                   function: "fetchAllProfile()",
                                                                   object: [ProfileDomain].self)
        }
    }
    
    public func insertUpdateProfile(_ profile: ProfileDomain, into storagePoint: StoragePoint) -> Observable<ProfileDomain> {
        switch storagePoint  {
        case .coreData:
            return self.localProfileStorage.insertIntoCoreData(profile)
        case .remote:
            return StoragePoint.makeRemoteStorageNotSupported(class: ProfileRepository.self,
                                                              function: "insertUpdateProfile()",
                                                              object: ProfileDomain.self)
        case .userDefaults:
            return self.localProfileStorage.insertIntoUserDefaults(profile)
        }
    }
    
    public func removeProfile(_ profile: ProfileDomain, in storagePoint: StoragePoint) -> Observable<ProfileDomain> {
        switch storagePoint  {
        case .coreData:
            return self.localProfileStorage.removeInCoreData(profile)
        case .remote:
            return StoragePoint.makeRemoteStorageNotSupported(class: ProfileRepository.self,
                                                              function: "removeProfile()",
                                                              object: ProfileDomain.self)
        case .userDefaults:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: ProfileRepository.self,
                                                                   function: "removeProfile()",
                                                                   object: ProfileDomain.self)
        }
    }
    
}

//
//  DefaultProfileRepository.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 15/04/21.
//

import Foundation
import RxSwift

class DefaultProfileRepository {
    
    let localProfileStorage: LocalProfileStorage
    
    init(localProfileStorage: LocalProfileStorage) {
        self.localProfileStorage = localProfileStorage
    }
    
}

extension DefaultProfileRepository: ProfileRepository {
    
    func fetchAllProfile(in storagePoint: StoragePoint) -> Single<[Profile]> {
        switch storagePoint  {
        case .coreData:
            return self.localProfileStorage.fetchAllInRealm()
        case .remote:
            return StoragePoint.makeRemoteStorageNotSupported(class: ProfileRepository.self,
                                                              function: "fetchAllProfile()",
                                                              object: [Profile].self)
        case .userDefaults:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: ProfileRepository.self,
                                                                   function: "fetchAllProfile()",
                                                                   object: [Profile].self)
        }
    }
    
    func insertProfile(_ profile: Profile, into storagePoint: StoragePoint) -> Single<Profile> {
        switch storagePoint  {
        case .coreData:
            return self.localProfileStorage.insertIntoRealm(profile)
        case .remote:
            return StoragePoint.makeRemoteStorageNotSupported(class: ProfileRepository.self,
                                                              function: "insertProfile()",
                                                              object: Profile.self)
        case .userDefaults:
            return self.localProfileStorage.insertIntoUserDefaults(profile)
        }
    }
    
    func removeProfile(_ profile: Profile, in storagePoint: StoragePoint) -> Single<Profile> {
        switch storagePoint  {
        case .coreData:
            return self.localProfileStorage.removeInRealm(profile)
        case .remote:
            return StoragePoint.makeRemoteStorageNotSupported(class: ProfileRepository.self,
                                                              function: "removeProfile()",
                                                              object: Profile.self)
        case .userDefaults:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: ProfileRepository.self,
                                                                   function: "removeProfile()",
                                                                   object: Profile.self)
        }
    }
    
}

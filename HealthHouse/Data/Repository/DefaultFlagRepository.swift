//
//  DefaultFlagRepository.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 18/05/21.
//

import Foundation
import RxSwift

class DefaultFlagRepository {
    
    let localActivityFlagStorage: LocalActivityFlagStorage
    let localFlagStorage: LocalFlagStorage
    
    init(localActivityFlagStorage: LocalActivityFlagStorage,
         localFlagStorage: LocalFlagStorage) {
        self.localActivityFlagStorage = localActivityFlagStorage
        self.localFlagStorage = localFlagStorage
    }
    
}

extension DefaultFlagRepository: FlagRepository {
    
    func fetchAllFlag(in storagePoint: StoragePoint) -> Single<[Flag]> {
        switch storagePoint {
        case .realm:
            return self.localFlagStorage.fetchAllInCoreData()
        case .remote:
            return StoragePoint.makeRemoteStorageNotSupported(class: FlagRepository.self,
                                                              function: "fetchAllFlag()",
                                                              object: [Flag].self)
        case .userDefaults:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: FlagRepository.self,
                                                                   function: "fetchAllFlag()",
                                                                   object: [Flag].self)
        }
    }
    
    func fetchAllFlag(ownedBy profile: Profile, in storagePoint: StoragePoint) -> Single<[Flag]> {
        switch storagePoint {
        case .realm:
            return self.localActivityFlagStorage
                .fetchAllInRealm(ownedBy: profile)
                .map({ $0.flatMap({ $0.flags }) })
        case .remote:
            return StoragePoint.makeRemoteStorageNotSupported(class: FlagRepository.self,
                                                              function: "fetchAllFlag()",
                                                              object: [Flag].self)
        case .userDefaults:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: FlagRepository.self,
                                                                   function: "fetchAllFlag()",
                                                                   object: [Flag].self)
        }
    }
    
    func insertFlag(_ flag: Flag, in storagePoint: StoragePoint) -> Single<Flag> {
        switch storagePoint {
        case .realm:
            return self.localFlagStorage.insertIntoCoreData(flag)
        case .remote:
            return StoragePoint.makeRemoteStorageNotSupported(class: FlagRepository.self,
                                                              function: "insertFlag()",
                                                              object: Flag.self)
        case .userDefaults:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: FlagRepository.self,
                                                                   function: "insertFlag()",
                                                                   object: Flag.self)
        }
    }
    
}

//
//  DefaultFlagRepository.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 18/05/21.
//

import Foundation
import RxSwift

public class DefaultFlagRepository {
    
    let localActivityFlagStorage: LocalActivityFlagStorage
    let localFlagStorage: LocalFlagStorage
    
    public init(localActivityFlagStorage: LocalActivityFlagStorage,
                localFlagStorage: LocalFlagStorage) {
        self.localActivityFlagStorage = localActivityFlagStorage
        self.localFlagStorage = localFlagStorage
    }
    
}

extension DefaultFlagRepository: FlagRepository {
    
    public func fetchAllFlag(in storagePoint: StoragePoint) -> Observable<[FlagDomain]> {
        switch storagePoint {
        case .coreData:
            return self.localFlagStorage.fetchAllInCoreData()
        case .remote:
            return StoragePoint.makeRemoteStorageNotSupported(class: FlagRepository.self,
                                                              function: "fetchAllFlag()",
                                                              object: [FlagDomain].self)
        case .userDefaults:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: FlagRepository.self,
                                                                   function: "fetchAllFlag()",
                                                                   object: [FlagDomain].self)
        }
    }
    
    public func fetchAllFlag(ownedBy profile: ProfileDomain,
                             in storagePoint: StoragePoint) -> Observable<[FlagDomain]> {
        switch storagePoint {
        case .coreData:
            return self.localActivityFlagStorage
                .fetchAllInCoreData(ownedBy: profile)
                .map({ $0.flatMap({ $0.flags }) })
        case .remote:
            return StoragePoint.makeRemoteStorageNotSupported(class: FlagRepository.self,
                                                              function: "fetchAllFlag()",
                                                              object: [FlagDomain].self)
        case .userDefaults:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: FlagRepository.self,
                                                                   function: "fetchAllFlag()",
                                                                   object: [FlagDomain].self)
        }
    }
    
    public func insertUpdateFlag(_ flag: FlagDomain, in storagePoint: StoragePoint) -> Observable<FlagDomain> {
        switch storagePoint {
        case .coreData:
            return self.localFlagStorage.insertIntoCoreData(flag)
        case .remote:
            return StoragePoint.makeRemoteStorageNotSupported(class: FlagRepository.self,
                                                              function: "insertUpdateFlag()",
                                                              object: FlagDomain.self)
        case .userDefaults:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: FlagRepository.self,
                                                                   function: "insertUpdateFlag()",
                                                                   object: FlagDomain.self)
        }
    }
    
}

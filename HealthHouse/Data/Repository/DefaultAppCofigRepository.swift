//
//  DefaultAppCofigRepository.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 29/05/21.
//

import Foundation
import RxSwift

public class DefaultAppCofigRepository {
    
    let localAppConfigStorage: LocalAppConfigStorage
    
    public init(localAppConfigStorage: LocalAppConfigStorage) {
        self.localAppConfigStorage = localAppConfigStorage
    }
    
}

extension DefaultAppCofigRepository: AppConfigRepository {
    
    public func fetchFirstLaunch(in storagePoint: StoragePoint) -> Single<Bool> {
        switch storagePoint {
        case .coreData:
            return StoragePoint.makeCoreDataStorageNotSupported(class: AppConfigRepository.self,
                                                                function: "fetchFirstLaunch()",
                                                                object: Bool.self).asSingle()
        case .remote:
            return StoragePoint.makeRemoteStorageNotSupported(class: AppConfigRepository.self,
                                                              function: "fetchFirstLaunch()",
                                                              object: Bool.self).asSingle()
        case .userDefaults:
            return self.localAppConfigStorage.fetchFirstLaunchFromUserDefaults()
        }
    }
    
    public func insertFirstLaunch(_ firstLaunch: Bool, in storagePoint: StoragePoint) -> Single<Bool> {
        switch storagePoint {
        case .coreData:
            return StoragePoint.makeCoreDataStorageNotSupported(class: AppConfigRepository.self,
                                                                function: "insertFirstLaunch(_:)",
                                                                object: Bool.self).asSingle()
        case .remote:
            return StoragePoint.makeRemoteStorageNotSupported(class: AppConfigRepository.self,
                                                              function: "insertFirstLaunch(_:)",
                                                              object: Bool.self).asSingle()
        case .userDefaults:
            return self.localAppConfigStorage.insertFirstLaunchIntoUserDefaults(firstLaunch)
        }
    }
    
}

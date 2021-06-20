//
//  DefaultProfileRepository.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 15/04/21.
//

import Foundation
import RxSwift

extension DefaultProfileRepository {
    
    func fetchProfile(in storagePoint: StoragePoint) -> Single<Profile?> {
        switch storagePoint  {
        case .realm:
            return StoragePoint.makeCoreDataStorageNotSupported(class: ProfileRepository.self,
                                                                function: "fetchProfile()",
                                                                object: Optional<Profile>.self)
        case .remote:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: ProfileRepository.self,
                                                                   function: "fetchProfile()",
                                                                   object: Optional<Profile>.self)
        case .userDefaults:
            return self.localProfileStorage
                .fetchInUserDefaults()
                .flatMap(self.fetchFirstProfileBy(realmID:))
        }
    }
    
}

private extension DefaultProfileRepository {
    
    func fetchFirstProfileBy(realmID profileID: ProfileID?) -> Single<Profile?> {
        self.localProfileStorage
            .fetchAllInRealm()
            .flatMap({ [unowned self] in
                return self.findFirstProfile($0, realmID: profileID)
            })
    }
    
    func findFirstProfile(_ profiles: [Profile], realmID ID: ProfileID?) -> Single<Profile?> {
        return .create { (observer) -> Disposable in
            let profile = profiles.first(where: { $0.realmID == ID })
            observer(.success(profile))
            return Disposables.create()
        }
    }
    
}

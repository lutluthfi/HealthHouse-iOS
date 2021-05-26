//
//  DefaultProfileRepository.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 15/04/21.
//

import Foundation
import RxSwift

extension DefaultProfileRepository {
    
    public func fetchProfile(in storagePoint: StoragePoint) -> Observable<ProfileDomain?> {
        switch storagePoint  {
        case .coreData:
            return StoragePoint.makeCoreDataStorageNotSupported(class: ProfileRepository.self,
                                                                function: "fetchProfile()",
                                                                object: Optional<ProfileDomain>.self)
        case .remote:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: ProfileRepository.self,
                                                                   function: "fetchProfile()",
                                                                   object: Optional<ProfileDomain>.self)
        case .userDefaults:
            return self.localProfileStorage
                .fetchInUserDefaults()
                .flatMap(self.fetchFirstProfileBy(coreID:))
        }
    }
    
}

private extension DefaultProfileRepository {
    
    func fetchFirstProfileBy(coreID url: URL?) -> Observable<ProfileDomain?> {
        self.localProfileStorage
            .fetchAllInCoreData()
            .flatMap({ [unowned self] in
                return self.findFirstProfile($0, coreID: url)
            })
    }
    
    func findFirstProfile(_ profiles: [ProfileDomain], coreID url: URL?) -> Observable<ProfileDomain?> {
        return Observable.create { (observer) -> Disposable in
            let profile = profiles.first(where: { $0.coreID?.uriRepresentation() == url })
            observer.onNext(profile)
            return Disposables.create()
        }
    }
    
}

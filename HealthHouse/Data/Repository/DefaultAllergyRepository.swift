//
//  DefaultAllergyRepository.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 03/07/21.
//

import Foundation
import RxSwift

final class DefaultAllergyRepository {
    
    let localAllergyStorage: LocalAllergyStorage
    let localProfileStorage: LocalProfileStorage
    
    init(localAllergyStorage: LocalAllergyStorage, localProfileStorage: LocalProfileStorage) {
        self.localAllergyStorage = localAllergyStorage
        self.localProfileStorage = localProfileStorage
    }
    
}

extension DefaultAllergyRepository: AllergyRepository {
    
    func fetchAllAllergy(ownedBy profile: Profile, in storagePoint: StoragePoint) -> Single<[Allergy]> {
        switch storagePoint {
        case .realm:
            return self.localAllergyStorage.fetchAllInRealm(ownedBy: profile)
        case .remote:
            return StoragePoint.makeRemoteStorageNotSupported(class: AllergyRepository.self,
                                                              function: "fetchAllAllergy(ownedBy:)",
                                                              object: [Allergy].self)
        case .userDefaults:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: AllergyRepository.self,
                                                                   function: "fetchAllAllergy(ownedBy:)",
                                                                   object: [Allergy].self)
        }
    }
    
    func insertUpdateAllergy(_ allergy: Allergy,
                             ownedBy profile: Profile,
                             into storagePoint: StoragePoint) -> Single<Allergy> {
        switch storagePoint {
        case .realm:
            return self.localProfileStorage
                .insertIntoRealm(profile)
                .flatMap { [unowned self] _ -> Single<Allergy> in
                    return self.localAllergyStorage.insertIntoRealm(allergy)
                }
        case .remote:
            return StoragePoint.makeRemoteStorageNotSupported(class: AllergyRepository.self,
                                                              function: "insertUpdateAllergy(_:,ownedBy:)",
                                                              object: Allergy.self)
        case .userDefaults:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: AllergyRepository.self,
                                                                   function: "insertUpdateAllergy(_:,ownedBy:)",
                                                                   object: Allergy.self)
        }
    }
    
    func removeAllergy(_ allergy: Allergy,
                       ownedBy profile: Profile,
                       in storagePoint: StoragePoint) -> Single<Allergy> {
        switch storagePoint {
        case .realm:
            return self.localProfileStorage
                .insertIntoRealm(profile)
                .flatMap { [unowned self] _ -> Single<Allergy> in
                    return self.localAllergyStorage.removeInRealm(allergy)
                }
        case .remote:
            return StoragePoint.makeRemoteStorageNotSupported(class: AllergyRepository.self,
                                                              function: "removeAllergy(_:,ownedBy:)",
                                                              object: Allergy.self)
        case .userDefaults:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: AllergyRepository.self,
                                                                   function: "removeAllergy(_:,ownedBy:)",
                                                                   object: Allergy.self)
        }
    }
    
}

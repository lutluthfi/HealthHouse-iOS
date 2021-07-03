//
//  LocalAllergyStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 03/07/21.
//

import Foundation
import RxSwift

protocol LocalAllergyStorage: RealmAllergyStorage {
    
}

final class DefaultLocalAllergyStorage: LocalAllergyStorage {
    
    let realmManager: RealmManagerShared
    
    init(realmManager: RealmManagerShared) {
        self.realmManager = realmManager
    }
    
}

// MARK: RealmAllergyStorage
extension DefaultLocalAllergyStorage {
    
    func fetchAllInRealm() -> Single<[Allergy]> {
        let objects = self.realmManager.realm.objects(AllergyRealm.self)
        let domains = Array(objects).toDomain()
        return .just(domains)
    }
    
    func fetchAllInRealm(ownedBy profile: Profile) -> Single<[Allergy]> {
        let profileRealm = self.realmManager.realm.object(ofType: ProfileRealm.self,
                                                          forPrimaryKey: profile.realmID)
        let allergyRealms = profileRealm?.allergyIDs.compactMap {
            self.realmManager.realm.object(ofType: AllergyRealm.self, forPrimaryKey: $0)
        } ?? []
        let allergyDomains = Array(allergyRealms).toDomain()
        return .just(allergyDomains)
    }
    
    func insertIntoRealm(_ allergy: Allergy) -> Single<Allergy> {
        let object = allergy.toRealm()
        return .create { [unowned self] observer in
            do {
                self.realmManager.realm.beginWrite()
                self.realmManager.realm.add(object, update: .error)
                try self.realmManager.realm.commitWrite()
            } catch {
                observer(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    func removeInRealm(_ allergy: Allergy) -> Single<Allergy> {
        let object = allergy.toRealm()
        return .create { [unowned self] observer in
            do {
                self.realmManager.realm.beginWrite()
                self.realmManager.realm.delete(object)
                try self.realmManager.realm.commitWrite()
            } catch {
                observer(.failure(error))
            }
            return Disposables.create()
        }
    }
    
}

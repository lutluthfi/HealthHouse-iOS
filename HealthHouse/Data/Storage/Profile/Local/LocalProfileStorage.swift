//
//  LocalProfileStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 03/04/21.
//

import RealmSwift
import RxRealm
import RxSwift

// MARK: LocalProfileRepository
protocol LocalProfileStorage: RealmProfileStorage, UserDefaultsProfileStorage {
}

// MARK: DefaultLocalProfileRepository
final class DefaultLocalProfileStorage: LocalProfileStorage {
    
    let realmManager: RealmManagerShared
    let userDefaultsProfileStorage: UserDefaultsProfileStorage
    
    init(realmManager: RealmManagerShared = RealmManager.sharedInstance(),
         userDefaultsProfileStorage: UserDefaultsProfileStorage = DefaultUserDefaultsProfileStorage()) {
        self.realmManager = realmManager
        self.userDefaultsProfileStorage = userDefaultsProfileStorage
    }
    
}

// MARK: RealmProfileStorage
extension DefaultLocalProfileStorage {
    
    func fetchAllInRealm() -> Single<[Profile]> {
        let objects = self.realmManager.realm.objects(ProfileRealm.self)
        let _objects = objects.toArray().toDomain()
        return .just(_objects)
    }
    
    func insertIntoRealm(_ profile: Profile) -> Single<Profile> {
        let object = profile.toRealm()
        return .create { [unowned self] (observer) in
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
    
    func removeInRealm(_ profile: Profile) -> Single<Profile> {
        let object = profile.toRealm()
        return .create { [unowned self] (observer) in
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

// MARK: UserDefaultsProfileStorage
extension DefaultLocalProfileStorage {
    
    func fetchInUserDefaults() -> Single<String?> {
        return self.userDefaultsProfileStorage.fetchInUserDefaults()
    }
    
    func insertIntoUserDefaults(_ profile: Profile) -> Single<Profile> {
        return self.userDefaultsProfileStorage.insertIntoUserDefaults(profile)
    }
    
}

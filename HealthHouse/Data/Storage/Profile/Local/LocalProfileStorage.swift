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
        let configuration = self.realmManager.configuration
        let observer = Realm.rx.add(configuration: configuration, update: .modified)
        let disposable = Observable.from(object: object).subscribe(observer)
        return .create { (_) in disposable }
    }
    
    func removeInRealm(_ profile: Profile) -> Single<Profile> {
        let object = profile.toRealm()
        let observer = Realm.rx.delete()
        let disposable = Observable.from(object: object).subscribe(observer)
        return .create { (_) in disposable }
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

//
//  LocalActivityFlagStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 16/05/21.
//

import RealmSwift
import RxSwift

// MARK: LocalActivityFlagStorage
protocol LocalActivityFlagStorage: RealmActivityFlagStorage {
    
}

// MARK: DefaultLocalActivityFlagStorage
final class DefaultLocalActivityFlagStorage: LocalActivityFlagStorage {
    
    let realmManager: RealmManagerShared
    
    init(realmManager: RealmManagerShared = RealmManager.sharedInstance()) {
        self.realmManager = realmManager
    }
    
}

// MARK: RealmActivityFlagStorage
extension DefaultLocalActivityFlagStorage {
    
    func fetchAllInRealm() -> Single<[ActivityFlag]> {
        let objects = self.realmManager.realm.objects(ActivityFlagRealm.self)
        let domains = Array(objects).toDomain()
        return .just(domains)
    }
    
    func fetchAllInRealm(ownedBy profile: Profile) -> Single<[ActivityFlag]> {
        let objects = self.realmManager.realm.objects(ActivityFlagRealm.self)
        var domains = Array(objects).toDomain()
        domains = domains.filter { $0.activity.profile == profile }
        return .just(domains)
    }
    
    func fetchInRealm(relatedTo activity: Activity) -> Single<ActivityFlag?> {
        let predicate = NSPredicate(format: "activityID = %@", activity.realmID)
        let object = self.realmManager.realm.objects(ActivityFlagRealm.self).filter(predicate).first
        let domain = object?.toDomain()
        return Observable.just(domain).asSingle()
    }
    
    func insertUpdateIntoRealm(_ activityFlag: ActivityFlag) -> Single<ActivityFlag> {
        let object = activityFlag.toRealm()
        return .create { [unowned self] (observer) in
            do {
                self.realmManager.realm.beginWrite()
                self.realmManager.realm.add(object, update: .error)
                try self.realmManager.realm.commitWrite()
                observer(.success(activityFlag))
            } catch {
                observer(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    func removeInRealm(relatedTo activity: Activity) -> Single<[ActivityFlag]> {
        let predicate = NSPredicate(format: "activityID = %@", activity.realmID)
        let objects = self.realmManager.realm.objects(ActivityFlagRealm.self).filter(predicate)
        let domains = Array(objects).toDomain()
        return .create { [unowned self] (observer) in
            do {
                self.realmManager.realm.beginWrite()
                self.realmManager.realm.delete(objects)
                try self.realmManager.realm.commitWrite()
                observer(.success(domains))
            } catch {
                observer(.failure(error))
            }
            return Disposables.create()
        }
    }
    
}

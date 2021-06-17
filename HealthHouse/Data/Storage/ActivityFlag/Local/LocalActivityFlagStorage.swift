//
//  LocalActivityFlagStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 16/05/21.
//

import RealmSwift
import RxRealm
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
        return Observable.array(from: objects).map({ $0.toDomain() }).asSingle()
    }
    
    func fetchAllInRealm(ownedBy profile: Profile) -> Single<[ActivityFlag]> {
        let objects = self.realmManager.realm.objects(ActivityFlagRealm.self)
        var domains = objects.toArray().toDomain()
        domains = domains.filter { $0.activity.profile == profile }
        return Observable.just(domains).asSingle()
    }
    
    func fetchInRealm(relatedTo activity: Activity) -> Single<ActivityFlag?> {
        let predicate = NSPredicate(format: "activityID = %@", activity.realmID)
        let object = self.realmManager.realm.objects(ActivityFlagRealm.self).filter(predicate).first
        let domain = object?.toDomain()
        return Observable.just(domain).asSingle()
    }
    
    func insertUpdateIntoRealm(_ activityFlag: ActivityFlag) -> Single<ActivityFlag> {
        let object = activityFlag.toRealm()
        let configuration = self.realmManager.configuration
        let observer = Realm.rx.add(configuration: configuration, update: .modified)
        let disposable = Observable.from(object: object).subscribe(observer)
        return .create { (_) in disposable }
    }
    
    func removeInRealm(relatedTo activity: Activity) -> Single<[ActivityFlag]> {
        let predicate = NSPredicate(format: "activityID = %@", activity.realmID)
        let objects = self.realmManager.realm.objects(ActivityFlagRealm.self).filter(predicate)
        let observer = Realm.rx.delete()
        let disposable = Observable.from(Array(objects)).subscribe(observer)
        return .create { (_) in disposable }
    }
    
}

//
//  LocalActivityStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 17/03/21.
//

import RealmSwift
import RxRealm
import RxSwift

// MARK: LocalActivityStorage
protocol LocalActivityStorage: RealmActivityStorage {
}

// MARK: DefaultLocalActivityStorage
class DefaultLocalActivityStorage: LocalActivityStorage {
    
    let realmManager: RealmManagerShared
    
    public init(realmManager: RealmManagerShared = RealmManager.sharedInstance()) {
        self.realmManager = realmManager
    }
    
}

// MARK: RealmActivityStorage
extension DefaultLocalActivityStorage {
    
    func fetchAllInCoreData() -> Single<[Activity]> {
        let objects = self.realmManager.realm.objects(ActivityRealm.self)
        return Observable.array(from: objects).map({ $0.toDomain() }).asSingle()
    }
    
    func fetchAllInCoreData(ownedBy profile: Profile) -> Single<[Activity]> {
        let predicate = NSPredicate(format: "profileID = %@", profile.realmID)
        let objects = self.realmManager.realm.objects(ActivityRealm.self).filter(predicate)
        return Observable.array(from: objects).map({ $0.toDomain() }).asSingle()
    }
    
    func fetchAllInCoreData(ownedBy profile: Profile,
                            onDoDate doDate: Int64) -> Single<[Activity]> {
        let predicate = NSPredicate(format: "profileID = %@ AND doDate = %@", profile.realmID, doDate)
        let objects = self.realmManager.realm.objects(ActivityRealm.self).filter(predicate)
        return Observable.array(from: objects).map({ $0.toDomain() }).asSingle()
    }
    
    func insertIntoCoreData(_ activity: Activity) -> Single<Activity> {
        let object = activity.toRealm()
        let configuration = self.realmManager.configuration
        let observer = Realm.rx.add(configuration: configuration, update: .modified)
        let disposable = Observable.from(object: object).subscribe(observer)
        return .create { (_) in disposable }
    }
    
    func removeInCoreData(_ activity: Activity) -> Single<Activity> {
        let object = activity.toRealm()
        let observer = Realm.rx.delete()
        let disposable = Observable.from(object: object).subscribe(observer)
        return .create { (_) in disposable }
    }
    
}

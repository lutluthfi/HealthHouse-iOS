//
//  LocalActivityStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 17/03/21.
//

import RealmSwift
import RxSwift

// MARK: LocalActivityStorage
protocol LocalActivityStorage: RealmActivityStorage {
}

// MARK: DefaultLocalActivityStorage
final class DefaultLocalActivityStorage: LocalActivityStorage {
    
    let realmManager: RealmManagerShared
    
    init(realmManager: RealmManagerShared) {
        self.realmManager = realmManager
    }
    
}

// MARK: RealmActivityStorage
extension DefaultLocalActivityStorage {
    
    func fetchAllInRealm() -> Single<[Activity]> {
        let objects = self.realmManager.realm.objects(ActivityRealm.self)
        let domains = Array(objects).toDomain()
        return .just(domains)
    }
    
    func fetchAllInRealm(ownedBy profile: Profile) -> Single<[Activity]> {
        let predicate = NSPredicate(format: "profileID = %@", profile.realmID)
        let objects = self.realmManager.realm.objects(ActivityRealm.self).filter(predicate)
        let domains = Array(objects).toDomain()
        return .just(domains)
    }
    
    func fetchAllInRealm(ownedBy profile: Profile,
                            onDoDate doDate: Date) -> Single<[Activity]> {
        let predicate = NSPredicate(format: "profileID = %@", profile.realmID)
        let objects = self.realmManager.realm.objects(ActivityRealm.self).filter(predicate)
        let _objects = objects.filter { $0.doDate.toDate().isSameDay(with: doDate) }
        let domains = Array(_objects).toDomain()
        return .just(domains)
    }
    
    func insertIntoRealm(_ activity: Activity) -> Single<Activity> {
        let object = activity.toRealm()
        return .create { [unowned self] (observer) in
            do {
                self.realmManager.realm.beginWrite()
                self.realmManager.realm.add(object, update: .error)
                try self.realmManager.realm.commitWrite()
                observer(.success(activity))
            } catch {
                observer(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    func removeInRealm(_ activity: Activity) -> Single<Activity> {
        let object = activity.toRealm()
        return .create { [unowned self] (observer) in
            do {
                self.realmManager.realm.beginWrite()
                self.realmManager.realm.delete(object)
                try self.realmManager.realm.commitWrite()
                observer(.success(activity))
            } catch {
                observer(.failure(error))
            }
            return Disposables.create()
        }
    }
    
}

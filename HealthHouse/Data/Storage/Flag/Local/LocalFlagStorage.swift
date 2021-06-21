//
//  LocalLabelStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 02/05/21.
//

import RealmSwift
import RxSwift

// MARK: LocalFlagStorage
protocol LocalFlagStorage: RealmFlagStorage {
}

// MARK: DefaultLocalFlagStorage
class DefaultLocalFlagStorage: LocalFlagStorage {
    
    let realmManager: RealmManagerShared
    
    init(realmManager: RealmManagerShared = RealmManager.sharedInstance()) {
        self.realmManager = realmManager
    }
    
}

// MARK: RealmFlagStorage
extension DefaultLocalFlagStorage {
    
    func fetchAllInCoreData() -> Single<[Flag]> {
        let objects = self.realmManager.realm.objects(FlagRealm.self)
        let domains = Array(objects).toDomain()
        return .just(domains)
    }
    
    func insertIntoCoreData(_ flag: Flag) -> Single<Flag> {
        let object = flag.toRealm()
        return .create { [unowned self] (observer) in
            do {
                self.realmManager.realm.beginWrite()
                self.realmManager.realm.add(object, update: .error)
                try self.realmManager.realm.commitWrite()
                observer(.success(flag))
            } catch {
                observer(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    func removeInCoreData(_ flag: Flag) -> Single<Flag> {
        let object = flag.toRealm()
        return .create { [unowned self] (observer) in
            do {
                self.realmManager.realm.beginWrite()
                self.realmManager.realm.delete(object)
                try self.realmManager.realm.commitWrite()
                observer(.success(flag))
            } catch {
                observer(.failure(error))
            }
            return Disposables.create()
        }
    }
    
}

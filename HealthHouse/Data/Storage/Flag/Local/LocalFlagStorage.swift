//
//  LocalLabelStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 02/05/21.
//

import RealmSwift
import RxRealm
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
        return Observable.array(from: objects).map({ $0.toDomain() }).asSingle()
    }
    
    func insertIntoCoreData(_ flag: Flag) -> Single<Flag> {
        let object = flag.toRealm()
        let configuration = self.realmManager.configuration
        let observer = Realm.rx.add(configuration: configuration, update: .modified)
        let disposable = Observable.from(object: object).subscribe(observer)
        return .create { (_) in disposable }
    }
    
    func removeInCoreData(_ flag: Flag) -> Single<Flag> {
        let object = flag.toRealm()
        let observer = Realm.rx.delete()
        let disposable = Observable.from(object: object).subscribe(observer)
        return .create { (_) in disposable }
    }
    
}

//
//  UserDefaultsProfileStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 03/04/21.
//

import CoreData
import Foundation
import RxSwift

// MARK: UserDefaultsProfileStorage
protocol UserDefaultsProfileStorage {
    
    func fetchInUserDefaults() -> Single<String?>
    
    func insertIntoUserDefaults(_ profile: Profile) -> Single<Profile>
    
}

// MARK: DefaultUserDefaultsProfileStorage
final class DefaultUserDefaultsProfileStorage {
    
    let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
}

extension DefaultUserDefaultsProfileStorage: UserDefaultsProfileStorage {
    
    var profileRealmID: String? {
        get { return self.userDefaults.string(forKey: self.profileRealmIDKey) }
        set { self.userDefaults.set(newValue, forKey: self.profileRealmIDKey) }
    }
    
    var profileRealmIDKey: String {
        return "ProfileRealmIDKey.UserDefaultsProfileStorage"
    }
    
    func fetchInUserDefaults() -> Single<String?> {
        return Observable.create { [unowned self] (observer) -> Disposable in
            observer.onNext(self.profileRealmID)
            observer.onCompleted()
            return Disposables.create()
        }
        .subscribe(on: ConcurrentMainScheduler.instance)
        .asSingle()
    }
    
    func insertIntoUserDefaults(_ profile: Profile) -> Single<Profile> {
        return Observable.create { [unowned self] (observer) -> Disposable in
            self.profileRealmID = profile.realmID
            observer.onNext(profile)
            observer.onCompleted()
            return Disposables.create()
        }
        .subscribe(on: ConcurrentMainScheduler.instance)
        .asSingle()
    }
    
}

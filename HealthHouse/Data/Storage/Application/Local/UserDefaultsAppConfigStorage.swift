//
//  UserDefaultsAppConfigStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 27/05/21.
//

import Foundation
import RxSwift

// MARK: UserDefaultsAppConfigStorage {
public protocol UserDefaultsAppConfigStorage {
    
    func fetchFirstLaunchFromUserDefaults() -> Single<Bool>
    
    func insertFirstLaunchIntoUserDefaults(_ firstLaunch: Bool) -> Single<Bool>
    
}

// MARK: DefaultUserDefaultsAppConfigStorage
public final class DefaultUserDefaultsAppConfigStorage {
    
    let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
}

extension DefaultUserDefaultsAppConfigStorage: UserDefaultsAppConfigStorage {
    
    var firstLaunch: Bool {
        get { return !self.userDefaults.bool(forKey: self.firstLaunchKey) }
        set { self.userDefaults.set(newValue, forKey: self.firstLaunchKey) }
    }
    
    var firstLaunchKey: String {
        return "FirstLaunchKey.UserDefaultsAppConfigStorage"
    }
    
    public func fetchFirstLaunchFromUserDefaults() -> Single<Bool> {
        return Single.create { [unowned self] (single) -> Disposable in
            let firstLaunch = self.firstLaunch
            single(.success(firstLaunch))
            return Disposables.create()
        }
        .subscribe(on: ConcurrentMainScheduler.instance)
    }
    
    public func insertFirstLaunchIntoUserDefaults(_ firstLaunch: Bool) -> Single<Bool> {
        return Single.create { [unowned self] (single) -> Disposable in
            self.firstLaunch = firstLaunch
            single(.success(firstLaunch))
            return Disposables.create()
        }
        .subscribe(on: ConcurrentMainScheduler.instance)
    }
    
}

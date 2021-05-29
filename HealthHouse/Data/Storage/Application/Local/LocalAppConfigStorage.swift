//
//  LocalAppConfigStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 27/05/21.
//

import Foundation
import RxSwift

// MARK: LocalAppConfigStorage
public protocol LocalAppConfigStorage: UserDefaultsAppConfigStorage {
}

// MARK: DefaultLocalAppConfigStorage
public final class DefaultLocalAppConfigStorage: LocalAppConfigStorage {
    
    let userDefaultsAppConfigStorage: UserDefaultsAppConfigStorage
    
    public init(userDefaultsAppConfigStorage: UserDefaultsAppConfigStorage = DefaultUserDefaultsAppConfigStorage()) {
        self.userDefaultsAppConfigStorage = userDefaultsAppConfigStorage
    }
    
}

// MARK: UserDefaultsAppConfigStorage
extension DefaultLocalAppConfigStorage {
    
    public func fetchFirstLaunchFromUserDefaults() -> Single<Bool> {
        return self.userDefaultsAppConfigStorage.fetchFirstLaunchFromUserDefaults()
    }
    
    public func insertFirstLaunchIntoUserDefaults(_ firstLaunch: Bool) -> Single<Bool> {
        return self.userDefaultsAppConfigStorage.insertFirstLaunchIntoUserDefaults(firstLaunch)
    }
    
}

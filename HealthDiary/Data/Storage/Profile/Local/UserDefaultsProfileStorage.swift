//
//  UserDefaultsProfileStorage.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 03/04/21.
//

import CoreData
import Foundation
import RxSwift

// MARK: UserDefaultsProfileStorage
public protocol UserDefaultsProfileStorage {
    
    func fetchInUserDefaults() -> Observable<URL?>
    
    func insertIntoUserDefaults(_ profile: ProfileDomain) -> Observable<ProfileDomain>
    
}

// MARK: DefaultUserDefaultsProfileStorage
public final class DefaultUserDefaultsProfileStorage {
    
    let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
}

extension DefaultUserDefaultsProfileStorage: UserDefaultsProfileStorage {
    
    var profileCoreID: URL? {
        get { return self.userDefaults.url(forKey: self.profileCoreIDKey) }
        set { self.userDefaults.set(newValue, forKey: self.profileCoreIDKey) }
    }
    
    var profileCoreIDKey: String {
        return "ProfileCoreIDKey.UserDefaultsProfileStorage"
    }
    
    public func fetchInUserDefaults() -> Observable<URL?> {
        return Observable.create { [unowned self] (observer) -> Disposable in
            observer.onNext(self.profileCoreID)
            observer.onCompleted()
            return Disposables.create()
        }.observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    public func insertIntoUserDefaults(_ profile: ProfileDomain) -> Observable<ProfileDomain> {
        return Observable.create { [unowned self] (observer) -> Disposable in
            self.profileCoreID = profile.coreID?.uriRepresentation()
            observer.onNext(profile)
            observer.onCompleted()
            return Disposables.create()
        }.observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
}

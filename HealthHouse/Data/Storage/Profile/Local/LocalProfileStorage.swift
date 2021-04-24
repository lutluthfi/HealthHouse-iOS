//
//  LocalProfileStorage.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 03/04/21.
//

import CoreData
import Foundation
import RxSwift

// MARK: LocalProfileRepository
public protocol LocalProfileStorage: CoreDataProfileStorage, UserDefaultsProfileStorage {
}

// MARK: DefaultLocalProfileRepository
public final class DefaultLocalProfileStorage: LocalProfileStorage {
    
    let coreDataStorage: CoreDataStorageShared
    let userDefaultsProfileStorage: UserDefaultsProfileStorage
    
    public init(coreDataStorage: CoreDataStorageShared = CoreDataStorage.shared,
                userDefaultsProfileStorage: UserDefaultsProfileStorage = DefaultUserDefaultsProfileStorage()) {
        self.coreDataStorage = coreDataStorage
        self.userDefaultsProfileStorage = userDefaultsProfileStorage
    }
    
}

// MARK: CoreDataProfileStorage
extension DefaultLocalProfileStorage {
    
    public func fetchAllInCoreData() -> Observable<[ProfileDomain]> {
        return Observable.create { [unowned self] (observer) -> Disposable in
            do {
                let context = self.coreDataStorage.context
                let request: NSFetchRequest = ProfileEntity.fetchRequest()
                let entities = try context.fetch(request)
                let domains = entities.map { $0.toDomain() }
                observer.onNext(domains)
                observer.onCompleted()
            } catch {
                let coreDataError = CoreDataStorageError.readError(error)
                observer.onError(coreDataError)
            }
            return Disposables.create()
        }
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .subscribe(on: ConcurrentMainScheduler.instance)
    }
    
    public func insertIntoCoreData(_ profile: ProfileDomain) -> Observable<ProfileDomain> {
        return Observable.create { [unowned self] (observer) -> Disposable in
            do {
                let context = self.coreDataStorage.context
                let inserted: ProfileEntity
                let request: NSFetchRequest = ProfileEntity.fetchRequest()
                let entities = try context.fetch(request)
                if let oldEntity = entities.first(where: { $0.objectID == profile.coreID }) {
                    inserted = oldEntity.createUpdate(with: profile, context: context)
                } else {
                    inserted = ProfileEntity(profile, insertInto: context)
                }
                try context.save()
                let insertedDomain = inserted.toDomain()
                observer.onNext(insertedDomain)
                observer.onCompleted()
            } catch {
                let coreDataError = CoreDataStorageError.saveError(error)
                observer.onError(coreDataError)
            }
            return Disposables.create()
        }
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .subscribe(on: ConcurrentMainScheduler.instance)
    }
    
    public func removeInCoreData(_ profile: ProfileDomain) -> Observable<ProfileDomain> {
        return Observable.create { [unowned self] (observer) -> Disposable in
            guard let coreID = profile.coreID else {
                let message = "LocalProfileStorage: Failed to execute removeInCoreData(_:) caused by coreID is not available"
                let error = PlainError(description: message)
                let coreDataError = CoreDataStorageError.deleteError(error)
                observer.onError(coreDataError)
                return Disposables.create()
            }
            
            do {
                let context = self.coreDataStorage.context
                let removedObject = context.object(with: coreID)
                context.delete(removedObject)
                try context.save()
                observer.onNext(profile)
                observer.onCompleted()
            } catch {
                let coreDataError = CoreDataStorageError.deleteError(error)
                observer.onError(coreDataError)
            }
            return Disposables.create()
        }
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .subscribe(on: ConcurrentMainScheduler.instance)
    }
    
}

// MARK: UserDefaultsProfileStorage
extension DefaultLocalProfileStorage {
    
    public func fetchInUserDefaults() -> Observable<URL?> {
        return self.userDefaultsProfileStorage.fetchInUserDefaults()
    }
    
    public func insertIntoUserDefaults(_ profile: ProfileDomain) -> Observable<ProfileDomain> {
        return self.userDefaultsProfileStorage.insertIntoUserDefaults(profile)
    }
    
}

//
//  LocalActivityFlagStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 16/05/21.
//

import CoreData
import Foundation
import RxSwift

// MARK: LocalActivityFlagStorage
public protocol LocalActivityFlagStorage: CoreDataActivityFlagStorage{
    
}

// MARK: DefaultLocalActivityFlagStorage
public class DefaultLocalActivityFlagStorage: LocalActivityFlagStorage {
    
    let coreDataStorage: CoreDataStorageShared
    
    public init(coreDataStorage: CoreDataStorageShared = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
}

// MARK: CoreDataActivityFlagStorage
extension DefaultLocalActivityFlagStorage {
    
    public func fetchAllInCoreData() -> Observable<[ActivityFlagDomain]> {
        return Observable.create { (observer) -> Disposable in
            do {
                let context = self.coreDataStorage.context
                let request: NSFetchRequest = ActivityFlagEntity.fetchRequest()
                let entities = try context.fetch(request)
                let domains = entities
                    .map({ $0.toDomain(context: context) })
                    .sorted(by: { $0.activity.createdAt < $1.activity.createdAt })
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
    
    public func fetchAllInCoreData(ownedBy profile: ProfileDomain) -> Observable<[ActivityFlagDomain]> {
        return Observable.create { (observer) -> Disposable in
            guard let profileCoreID = profile.coreID else {
                let message = "LocalActivityFlagStorage: Failed to execute fetchAllInCoreData(ownedBy:) caused by profileCoreID is not available"
                let error = PlainError(description: message)
                let coreDataError = CoreDataStorageError.deleteError(error)
                observer.onError(coreDataError)
                return Disposables.create()
            }
            
            do {
                let context = self.coreDataStorage.context
                let request: NSFetchRequest = ActivityEntity.fetchRequest()
                request.predicate = NSPredicate(format: "profileID = %@", profileCoreID)
                let activityEntities = try context.fetch(request)
                let activityFlagEntities = activityEntities
                    .compactMap({ (activityEntity) -> [ActivityFlagEntity]? in
                        let request: NSFetchRequest = ActivityFlagEntity.fetchRequest()
                        request.predicate = NSPredicate(format: "activityID = %@", activityEntity.objectID)
                        return try? context.fetch(request)
                    })
                    .flatMap({ $0 })
                let activityFlagDomains = activityFlagEntities
                    .map({ $0.toDomain(context: context) })
                    .sorted(by: { $0.activity.createdAt < $1.activity.createdAt })
                observer.onNext(activityFlagDomains)
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
    
    public func fetchInCoreData(relatedTo activity: ActivityDomain) -> Observable<ActivityFlagDomain> {
        return Observable.create { (observer) -> Disposable in
            guard let activityCoreID = activity.coreID else {
                let message = "LocalActivityFlagStorage: Failed to execute fetchAllInCoreData(activity:) caused by activityCoreID is not available"
                let error = PlainError(description: message)
                let coreDataError = CoreDataStorageError.deleteError(error)
                observer.onError(coreDataError)
                return Disposables.create()
            }
            
            do {
                let context = self.coreDataStorage.context
                let request: NSFetchRequest = ActivityFlagEntity.fetchRequest()
                request.predicate = NSPredicate(format: "activityID = %@", activityCoreID)
                let entities = try context.fetch(request)
                
                guard let entity = entities.first else {
                    let message = "LocalActivityFlagStorage: Failed to execute fetchAllInCoreData(activity:) caused by activityCoreID is not found"
                    let error = PlainError(description: message)
                    let coreDataError = CoreDataStorageError.deleteError(error)
                    observer.onError(coreDataError)
                    return Disposables.create()
                }
                
                let domain = entity.toDomain(context: context)
                observer.onNext(domain)
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
    
    public func insertUpdateIntoCoreData(_ activityFlag: ActivityFlagDomain) -> Observable<ActivityFlagDomain> {
        return Observable.create { (observer) -> Disposable in
            guard activityFlag.activity.coreID != nil else {
                let message = "LocalActivityFlagStorage: Failed to execute insertUpdateIntoCoreData(_:) caused by activityCoreID is not available"
                let error = PlainError(description: message)
                let coreDataError = CoreDataStorageError.deleteError(error)
                observer.onError(coreDataError)
                return Disposables.create()
            }
            
            do {
                let context = self.coreDataStorage.context
                let inserted: ActivityFlagEntity
                let request: NSFetchRequest = ActivityFlagEntity.fetchRequest()
                let entities = try context.fetch(request)
                if let oldEntity = entities.first(where: { $0.objectID == activityFlag.coreID }) {
                    inserted = oldEntity.createUpdate(with: activityFlag, context: context)
                } else {
                    inserted = ActivityFlagEntity(activityFlag, insertInto: context)
                }
                try context.save()
                let insertedDomain = inserted.toDomain(context: context)
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
    
    public func removeInCoreData(relatedTo activity: ActivityDomain) -> Observable<ActivityFlagDomain> {
        return Observable.create { (observer) -> Disposable in
            guard let activityCoreID = activity.coreID else {
                let message = "LocalActivityFlagStorage: Failed to execute removeInCoreData(activity:) caused by activityCoreID is not available"
                let error = PlainError(description: message)
                let coreDataError = CoreDataStorageError.deleteError(error)
                observer.onError(coreDataError)
                return Disposables.create()
            }
            
            do {
                let context = self.coreDataStorage.context
                let request: NSFetchRequest = ActivityFlagEntity.fetchRequest()
                request.predicate = NSPredicate(format: "activityID = %@", activityCoreID)
                let entities = try context.fetch(request)
                
                guard let removedEntity = entities.first else {
                    let message = "LocalActivityFlagStorage: Failed to execute removeInCoreData(activity:) caused by activityCoreID is not found"
                    let error = PlainError(description: message)
                    let coreDataError = CoreDataStorageError.deleteError(error)
                    observer.onError(coreDataError)
                    return Disposables.create()
                }
                
                let removedDomain = removedEntity.toDomain(context: context)
                context.delete(removedEntity)
                try context.save()
                
                observer.onNext(removedDomain)
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
    
}

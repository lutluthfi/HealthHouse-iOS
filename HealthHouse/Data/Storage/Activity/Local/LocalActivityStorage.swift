//
//  LocalActivityStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 17/03/21.
//

import CoreData
import Foundation
import RxSwift

// MARK: LocalActivityStorage
public protocol LocalActivityStorage: CoreDataActivityStorage {
}

// MARK: DefaultLocalActivityStorage
public class DefaultLocalActivityStorage: LocalActivityStorage {
    
    let coreDataStorage: CoreDataStorageShared
    
    public init(coreDataStorage: CoreDataStorageShared = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
}

// MARK: CoreDataActivityStorage
extension DefaultLocalActivityStorage {
    
    public func fetchAllInCoreData() -> Observable<[ActivityDomain]> {
        return Observable.create { [unowned self] (observer) -> Disposable in
            do {
                let context = self.coreDataStorage.context
                let request: NSFetchRequest = ActivityEntity.fetchRequest()
                let entities = try context.fetch(request)
                let domains = entities.map { $0.toDomain(context: context) }
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
    
    public func fetchAllInCoreData(ownedBy profile: ProfileDomain) -> Observable<[ActivityDomain]> {
        return Observable.create { [unowned self] (observer) -> Disposable in
            guard let profileCoreID = profile.coreID else {
                let message = "LocalActivityStorage: Failed to execute fetchAllInCoreData(ownedBy:) caused by profileCoreID is not available"
                let error = PlainError(description: message)
                let coreDataError = CoreDataStorageError.deleteError(error)
                observer.onError(coreDataError)
                return Disposables.create()
            }
            do {
                let context = self.coreDataStorage.context
                let request: NSFetchRequest = ActivityEntity.fetchRequest()
                request.predicate = NSPredicate(format: "profileID = %@", profileCoreID)
                let entities = try context.fetch(request)
                let domains = entities.map { $0.toDomain(context: context) }
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
    
    public func fetchAllInCoreData(ownedBy profile: ProfileDomain,
                                   onDoDate doDate: Int64) -> Observable<[ActivityDomain]> {
        return Observable.create { [unowned self] (observer) -> Disposable in
            guard let profileCoreID = profile.coreID else {
                let message = "LocalActivityStorage: Failed to execute fetchAllInCoreData(ownedBy:, onDoDate:) caused by profileCoreID is not available"
                let error = PlainError(description: message)
                let coreDataError = CoreDataStorageError.deleteError(error)
                observer.onError(coreDataError)
                return Disposables.create()
            }
            do {
                let context = self.coreDataStorage.context
                let request: NSFetchRequest = ActivityEntity.fetchRequest()
                request.predicate = NSPredicate(format: "profileID = %@", profileCoreID)
                let entities = try context.fetch(request)
                let domains = entities
                    .map { $0.toDomain(context: context) }
                    .filter { (activity) -> Bool in
                        let formatter: [Date.FormatterComponent] = [.dayOfMonthPadding,
                                                                    .monthOfYearDouble,
                                                                    .yearFullDigits]
                        let doDateFormatted = doDate.toDate().formatted(components: formatter)
                        let activityDoDateFormatted = activity.doDate.toDate().formatted(components: formatter)
                        return doDateFormatted == activityDoDateFormatted
                    }
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
    
    public func insertIntoCoreData(_ activity: ActivityDomain) -> Observable<ActivityDomain> {
        return Observable.create { [unowned self] (observer) -> Disposable in
            guard activity.profile.coreID != nil else {
                let error = PlainError(description: "LocalActivityStorage: Failed to execute insertIntoCoreData() caused by Profile coreID is not available")
                let coreDataError = CoreDataStorageError.saveError(error)
                observer.onError(coreDataError)
                return Disposables.create()
            }
            do {
                let context = self.coreDataStorage.context
                let inserted: ActivityEntity
                let request: NSFetchRequest = ActivityEntity.fetchRequest()
                let entities = try context.fetch(request)
                if let oldEntity = entities.first(where: { $0.objectID == activity.coreID }) {
                    inserted = oldEntity.createUpdate(with: activity, context: context)
                } else {
                    inserted = ActivityEntity(activity, insertInto: context)
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
    
    public func removeInCoreData(_ activity: ActivityDomain) -> Observable<ActivityDomain> {
        return Observable.create { [unowned self] (observer) -> Disposable in
            guard let coreID = activity.coreID else {
                let message = "LocalActivityStorage: Failed to execute removeInCoreData() caused by coreID is not available"
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
                observer.onNext(activity)
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

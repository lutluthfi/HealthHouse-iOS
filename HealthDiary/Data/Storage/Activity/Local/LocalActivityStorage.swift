//
//  LocalActivityStorage.swift
//  HealthDiary
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
        }.observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    public func insertIntoCoreData(_ activity: ActivityDomain) -> Observable<ActivityDomain> {
        return Observable.create { [unowned self] (observer) -> Disposable in
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
        }.observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    public func removeInCoreData(_ activity: ActivityDomain) -> Observable<ActivityDomain> {
        return Observable.create { [unowned self] (observer) -> Disposable in
            guard let coreID = activity.coreID else {
                let message = "LocalActivityStorage: Failed to execute removeInCoreData(_:) caused by coreID is not available"
                let error = NSError(domain: message, code: 0, userInfo: nil)
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
        }.observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
}

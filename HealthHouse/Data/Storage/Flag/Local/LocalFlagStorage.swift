//
//  LocalLabelStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 02/05/21.
//

import CoreData
import Foundation
import RxSwift

// MARK: LocalFlagStorage
public protocol LocalFlagStorage: CoreDataFlagStorage {
}

// MARK: DefaultLocalFlagStorage
public class DefaultLocalFlagStorage: LocalFlagStorage {
    
    let coreDataStorage: CoreDataStorageShared
    
    public init(coreDataStorage: CoreDataStorageShared = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
}

// MARK: CoreDataFlagStorage
extension DefaultLocalFlagStorage {
    
    public func fetchAllInCoreData() -> Observable<[FlagDomain]> {
        return Observable.create { [unowned self] (observer) -> Disposable in
            do {
                let context = self.coreDataStorage.context
                let request: NSFetchRequest = FlagEntity.fetchRequest()
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
    
    public func insertIntoCoreData(_ flag: FlagDomain) -> Observable<FlagDomain> {
        return Observable.create { [unowned self] (observer) -> Disposable in
            do {
                let context = self.coreDataStorage.context
                let inserted: FlagEntity
                let request: NSFetchRequest = FlagEntity.fetchRequest()
                let entities = try context.fetch(request)
                if let oldEntity = entities.first(where: { $0.objectID == flag.coreID }) {
                    inserted = oldEntity.createUpdate(with: flag, context: context)
                } else {
                    inserted = FlagEntity(flag, insertInto: context)
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
    
    public func removeInCoreData(_ flag: FlagDomain) -> Observable<FlagDomain> {
        return Observable.create { [unowned self] (observer) -> Disposable in
            guard let coreID = flag.coreID else {
                let message = "LocalFlagStorage: Failed to execute removeInCoreData() caused by coreID is not available"
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
                observer.onNext(flag)
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

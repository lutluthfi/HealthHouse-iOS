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
            guard flag.coreID == nil else {
                let message = "LocalFlagStorage: Failed to execute insertIntoCoreData() caused by flagCoreID is already exist"
                let error = PlainError(description: message)
                let coreDataError = CoreDataStorageError.saveError(error)
                observer.onError(coreDataError)
                return Disposables.create()
            }
            
            do {
                let context = self.coreDataStorage.context
                let inserted: FlagEntity
                let request: NSFetchRequest = FlagEntity.fetchRequest()
                let entities = try context.fetch(request)
                
                guard !entities.contains(where: { $0.name == flag.name }) else {
                    let message = "LocalFlagStorage: Failed to execute insertIntoCoreData() caused by Flag is already created"
                    let error = PlainError(description: message)
                    let coreDataError = CoreDataStorageError.saveError(error)
                    observer.onError(coreDataError)
                    return Disposables.create()
                }
                
                inserted = FlagEntity(flag, insertInto: context)
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

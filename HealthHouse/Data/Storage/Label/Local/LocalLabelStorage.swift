//
//  LocalLabelStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 02/05/21.
//

import CoreData
import Foundation
import RxSwift

// MARK: LocalActivityStorage
public protocol LocalLabelStorage: CoreDataLabelStorage {
}

// MARK: DefaultLocalActivityStorage
public class DefaultLocalLabelStorage: LocalLabelStorage {
    
    let coreDataStorage: CoreDataStorageShared
    
    public init(coreDataStorage: CoreDataStorageShared = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
}

// MARK: CoreDataLabelStorage
extension DefaultLocalLabelStorage {
    
    public func fetchAllInCoreData() -> Observable<[LabelDomain]> {
        return Observable.create { [unowned self] (observer) -> Disposable in
            do {
                let context = self.coreDataStorage.context
                let request: NSFetchRequest = LabelEntity.fetchRequest()
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
    
    public func insertIntoCoreData(_ label: LabelDomain) -> Observable<LabelDomain> {
        return Observable.create { [unowned self] (observer) -> Disposable in
            do {
                let context = self.coreDataStorage.context
                let inserted: LabelEntity
                let request: NSFetchRequest = LabelEntity.fetchRequest()
                let entities = try context.fetch(request)
                if let oldEntity = entities.first(where: { $0.objectID == label.coreID }) {
                    inserted = oldEntity.createUpdate(with: label, context: context)
                } else {
                    inserted = LabelEntity(label, insertInto: context)
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
    
    public func removeInCoreData(_ label: LabelDomain) -> Observable<LabelDomain> {
        return Observable.create { [unowned self] (observer) -> Disposable in
            guard let coreID = label.coreID else {
                let message = "LocalLabelStorage: Failed to execute removeInCoreData() caused by coreID is not available"
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
                observer.onNext(label)
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

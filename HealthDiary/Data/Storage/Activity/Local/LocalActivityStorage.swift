//
//  LocalActivityStorage.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 17/03/21.
//

import CoreData
import Foundation
import RxSwift

public protocol LocalActivityStorage: ActivityStorage {
    
    func fetchAllActivity() -> Observable<[ActivityDomain]>
    
    func insertIntoCoreData(_ activity: ActivityDomain) -> Observable<ActivityDomain>
    
}

public class DefaultLocalActivityStorage {
    
    let coreDataStorage: CoreDataStorageShared
    
    public init(coreDataStorage: CoreDataStorageShared = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
}

extension DefaultLocalActivityStorage: LocalActivityStorage {
    
    public func fetchAllActivity() -> Observable<[ActivityDomain]> {
        return Observable<[ActivityDomain]>.create { [unowned self] (observer) -> Disposable in
            self.coreDataStorage.performBackgroundTask { (context) in
                do {
                    let request: NSFetchRequest = ActivityEntity.fetchRequest()
                    let entities = try request.execute()
                    let domains = entities.map { $0.toDomain() }
                    observer.onNext(domains)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }.observeOn(MainScheduler.instance)
    }
    
    public func insertIntoCoreData(_ activity: ActivityDomain) -> Observable<ActivityDomain> {
        return Observable<ActivityDomain>.create { [unowned self] (observer) -> Disposable in
            self.coreDataStorage.performBackgroundTask { (context) in
                do {
                    let inserted: ActivityEntity
                    let request: NSFetchRequest = ActivityEntity.fetchRequest()
                    let entities = try request.execute()
                    if let oldEntity = entities.first(where: { $0.objectID == activity.coreId }) {
                        inserted = oldEntity.createUpdate(with: activity, context: context)
                    } else {
                        inserted = ActivityEntity(activity, insertInto: context)
                    }
                    try context.save()
                    let insertedDomain = inserted.toDomain()
                    observer.onNext(insertedDomain)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }.observeOn(MainScheduler.instance)
    }
    
}

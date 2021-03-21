//
//  CoreDataStorage.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 17/03/21.

import CoreData
import Foundation

public enum CoreDataStorageError: Error {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
}

public protocol CoreDataStorageShared {
    
    var containerName: String { get }
    
    var fetchCollectionTimeout: TimeInterval { get }
    
    var fetchElementTimeout: TimeInterval { get }
    
    var insertCollectionTimeout: TimeInterval { get }
    
    var insertElementTimeout: TimeInterval { get }
    
    var removeCollectionTimeout: TimeInterval { get }
    
    var removeElementTimeout: TimeInterval { get }
    
    func saveContext()
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)
    
}

public final class CoreDataStorage {
    
    public static let shared: CoreDataStorageShared = CoreDataStorage()
    
    private init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.containerName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                debugPrint("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
}

extension CoreDataStorage: CoreDataStorageShared {
    
    public var containerName: String {
        return "CoreDataStorage"
    }
    
    public var fetchCollectionTimeout: TimeInterval {
        return TimeInterval(5)
    }
    
    public var fetchElementTimeout: TimeInterval {
        return TimeInterval(5)
    }
    
    public var insertCollectionTimeout: TimeInterval {
        return TimeInterval(5)
    }
    
    public var insertElementTimeout: TimeInterval {
        return TimeInterval(5)
    }
    
    public var removeCollectionTimeout: TimeInterval {
        return TimeInterval(5)
    }
    
    public var removeElementTimeout: TimeInterval {
        return TimeInterval(5)
    }
    
    public func saveContext() {
        let context = self.persistentContainer.viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            debugPrint("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
        }
    }
    
    public func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.persistentContainer.performBackgroundTask(block)
    }
    
}
//
//  CoreDataStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 17/03/21.

import CoreData
import Foundation

public enum CoreDataStorageError {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
}

extension CoreDataStorageError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .deleteError(let error):
            return "CoreDataStorageError [DELETE] -> \(error.localizedDescription)"
        case .readError(let error):
            return "CoreDataStorageError [READ] -> \(error.localizedDescription)"
        case .saveError(let error):
            return "CoreDataStorageError [SAVE] -> \(error.localizedDescription)"
        }
    }
    
}

public protocol CoreDataStorageShared {
    
    var containerName: String { get }
    
    var context: NSManagedObjectContext { get }
    
    var fetchCollectionTimeout: TimeInterval { get }
    
    var fetchElementTimeout: TimeInterval { get }
    
    var insertCollectionTimeout: TimeInterval { get }
    
    var insertElementTimeout: TimeInterval { get }
    
    var removeCollectionTimeout: TimeInterval { get }
    
    var removeElementTimeout: TimeInterval { get }
    
    func saveContext()
    
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
    
    public var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
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
        do {
            try context.save()
        } catch {
            debugPrint("CoreDataStorage -> saveContext() unresolved error \(error), \((error as NSError).userInfo)")
        }
    }
    
}
